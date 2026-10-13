resource "google_compute_instance" "cvm" {
  name = var.cvm_name
  machine_type = var.cvm_size
  labels = local.annotations

  boot_disk {
    initialize_params {
      image = var.cvm_os
    }
  }

  network_interface {
    network = google_compute_network.cvm.id
    access_config {
      // Include this section to assign the VM an external IP address
    }
  }

  metadata = merge({
    // WARNING: it's user-data with "-" and not "_" as for other providers. No base64encode encoding.
    user-data = var.remote_attestation != null ? templatefile("${path.module}/../../cloud-init/attested.yml",
        {
          HOSTNAME                           = var.cvm_name
          USERNAME                           = var.cvm_username
          SSH_PUBKEY                         = file(var.cvm_ssh_pubkey)
          OS_NAME                            = var.os_name
          // CanaryBit Remote Attestation
          CB_INSPECTOR_URL                   = var.remote_attestation.cb_inspector_url
          CB_INSPECTOR_CLIENT_V              = var.remote_attestation.cb_inspector_client_version
          CBCLI_V                            = var.remote_attestation.cbcli_version
          ENVIRONMENTS                       = var.remote_attestation.environments
          CUSTOM_POLICY_OPT                  = var.remote_attestation.custom_policy_file != null ? "--policy /etc/canarybit/custom-policy.rego" : ""
          CUSTOM_POLICY                      = var.remote_attestation.custom_policy_file != null ? indent(6,file(var.remote_attestation.custom_policy_file)) : ""
          FREQUENCY                          = var.remote_attestation.frequency
          CB_INSPECTOR_CLIENT_ANNOTATIONS    = join(",", formatlist("%s=%s", keys(local.annotations), values(local.annotations)))
        }
      ) : templatefile("${path.module}/../../cloud-init/default.yml",
        {
          HOSTNAME           = var.cvm_name
          USERNAME           = var.cvm_username
          SSH_PUBKEY         = file(var.cvm_ssh_pubkey)
        }
    )
  }, var.os_name == "rhel" ? {
    "ssh-keys"       = "${var.cvm_username}:${trimspace(file(var.cvm_ssh_pubkey))}"
    "enable-oslogin" = "FALSE"
    "startup-script" = <<-EOT
      #!/bin/bash
      set -euo pipefail

      if ! command -v cloud-init >/dev/null 2>&1; then
        dnf --disablerepo='*debug*' --disablerepo='*source*' -y install cloud-init
        systemctl enable cloud-init-local.service cloud-init.service cloud-config.service cloud-final.service
      else
        systemctl enable cloud-init-local.service cloud-init.service cloud-config.service cloud-final.service
      fi
    EOT
  } : {})

  shielded_instance_config {
    enable_secure_boot = true
    enable_vtpm = true
    enable_integrity_monitoring = true
  }

  allow_stopping_for_update = false

  confidential_instance_config {
    confidential_instance_type = [for k,l in local.cvm_size_cpu_type_map : k if anytrue([for v in l : startswith(var.cvm_size,v)])][0]
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }

  # Enable ssh connection, create a file containing the cbtoken and launch the script
  connection {
    type = "ssh"
    user = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey,".pub"))
    host = self.network_interface.0.access_config.0.nat_ip
    timeout = var.os_name == "rhel" ? "10m" : null
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/tokens"
    content = "CB_TOKENS='${data.http.cblogin.*.response_body[0]}'"
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/signing-key.pem"
    content = tls_private_key.rsa-4096.private_key_pem_pkcs8
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "null_resource" "cloud_init_reboot" {
  count      = var.os_name == "rhel" ? 1 : 0
  depends_on = [google_compute_instance.cvm]

  triggers = {
    instance_id = google_compute_instance.cvm.id
    os_name     = var.os_name
  }

  connection {
    type        = "ssh"
    user        = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey, ".pub"))
    host        = google_compute_instance.cvm.network_interface[0].access_config[0].nat_ip
    timeout     = var.os_name == "rhel" ? "10m" : null
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init installation'",
      "for i in $(seq 1 120); do command -v cloud-init >/dev/null 2>&1 && break; sleep 5; done",
      "command -v cloud-init >/dev/null 2>&1 || { echo 'Timed out waiting for cloud-init installation' >&2; exit 1; }",
      "sudo systemd-run --no-block --unit=terraform-cloud-init-reboot --on-active=10s /usr/sbin/reboot",
    ]
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      host="${google_compute_instance.cvm.network_interface[0].access_config[0].nat_ip}"
      deadline=$((SECONDS + 600))

      while (( SECONDS < deadline )); do
        if ! timeout 2 bash -c ":</dev/tcp/$host/22" 2>/dev/null; then
          break
        fi
        sleep 2
      done

      if (( SECONDS >= deadline )); then
        echo "Timed out waiting for SSH to disconnect during reboot" >&2
        exit 1
      fi

      while (( SECONDS < deadline )); do
        if timeout 2 bash -c ":</dev/tcp/$host/22" 2>/dev/null; then
          echo "VM is back after reboot"
          exit 0
        fi
        sleep 2
      done

      echo "Timed out waiting for SSH after reboot" >&2
      exit 1
    EOT
  }
}

resource "null_resource" "attestation" {
  count = var.remote_attestation != null ? 1 : 0

  depends_on = [null_resource.cloud_init_reboot]

  triggers = {
    instance_id = google_compute_instance.cvm.id
    os_name     = var.os_name
  }

  connection {
    type        = "ssh"
    user        = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey, ".pub"))
    host        = google_compute_instance.cvm.network_interface[0].access_config[0].nat_ip
    timeout     = var.os_name == "rhel" ? "10m" : null
  }

  provisioner "remote-exec" {
    inline = var.os_name == "rhel" ? [
      "echo 'Waiting for cloud-init installation'",
      "for i in $(seq 1 120); do command -v cloud-init >/dev/null 2>&1 && break; sleep 5; done",
      "command -v cloud-init >/dev/null 2>&1 || { echo 'Timed out waiting for cloud-init installation' >&2; exit 1; }",
      "sudo timeout 20m cloud-init status --wait --long",
      "sudo test -x /etc/canarybit/launch-cb-inspector-client || { echo 'Cloud-init did not create /etc/canarybit/launch-cb-inspector-client; inspect cloud-init status and logs.' >&2; exit 1; }",
      "echo 'Running attestation launcher'",
      "sudo timeout 10m /etc/canarybit/launch-cb-inspector-client",
      "echo 'Attestation launcher finished'",
    ] : [
      "if command -v cloud-init >/dev/null 2>&1; then cloud-init status --wait; fi",
      "sudo /etc/canarybit/launch-cb-inspector-client",
    ]
  }
}
