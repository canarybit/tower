///////////////////////
// AMD SNP
///////////////////////

resource "aws_instance" "cvm" {
  ami = var.cvm_os
  instance_type = var.cvm_size
  tags = merge(
    { Name = var.cvm_name },
    local.annotations
  )
  
  // Select the right cloud-init: with Remote Attestation support or default.
  user_data_base64 = var.remote_attestation != null ? base64gzip(templatefile("${path.module}/../../cloud-init/attested.yml",
      {
        HOSTNAME                = var.cvm_name
        USERNAME                = var.cvm_username
        SSH_PUBKEY              = file(var.cvm_ssh_pubkey)
        // CanaryBit Remote Attestation
        CB_TOKENS               = data.http.cblogin.*.response_body[0]
        CBINSPECTOR_URL         = var.remote_attestation.cbinspector_url
        CBCLIENT_V              = var.remote_attestation.cbclient_version
        CBCLI_V                 = var.remote_attestation.cbcli_version
        ENVIRONMENTS            = var.remote_attestation.environments
        CUSTOM_POLICY_OPT       = var.remote_attestation.custom_policy_file != null ? "--policy /etc/canarybit/custom-policy.rego" : ""
        CUSTOM_POLICY           = var.remote_attestation.custom_policy_file != null ? indent(6,file(var.remote_attestation.custom_policy_file)) : ""
        FREQUENCY               = var.remote_attestation.frequency
        SIGNING_KEY             = indent(6,tls_private_key.rsa-4096.private_key_pem_pkcs8)
        CBCLIENT_ANNOTATIONS    = replace(join(",", formatlist("%s=%s", keys(local.annotations), values(local.annotations))),":","/")
      }
    )) : base64gzip(templatefile("${path.module}/../../cloud-init/default.yml",
      {
        HOSTNAME           = var.cvm_name
        USERNAME           = var.cvm_username
        SSH_PUBKEY         = file(var.cvm_ssh_pubkey)
      }
    )
  )

  vpc_security_group_ids = [aws_security_group.default.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.cvm_disk_size_gb
    delete_on_termination = true
  }

  cpu_options {
    amd_sev_snp = strcontains(var.remote_attestation.environments, "snp") ? "enabled" : null // Enable AMD SEV-SNP
  }

  # Enable ssh connection, create a file containing the cbtoken and launch the script
  connection {
    type = "ssh"
    user = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey,".pub"))
    host = self.public_ip
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/tokens"
    content = "CB_TOKENS='${data.http.cblogin.*.response_body[0]}'"
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/signing-key.pem"
    content = tls_private_key.rsa-4096.private_key_pem_pkcs8
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo /etc/canarybit/launch-cbclient",
    ]
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}