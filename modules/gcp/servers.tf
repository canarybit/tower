resource "google_compute_instance" "cvm" {
  name = var.cvm_name
  machine_type = var.cvm_size
  labels = local.annotations // TODO: add enclave id here?

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

  metadata = {
    // WARNING: it's user-data with "-" and not "_" as for other providers. No base64encode encoding.
    user-data = module.commons.cloud_init_user_data
  }

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
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/tokens"
    content = "CB_TOKENS='${module.commons.cb_tokens}'"
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/signing-key.pem"
    content = module.commons.signing_key_pem
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo /etc/canarybit/launch-cb-inspector-client",
    ]
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
