///////////////////////
// AMD SNP
///////////////////////

resource "aws_instance" "cvm" {
  ami = var.cvm_os
  instance_type = var.cvm_size
  tags = merge(
    {
      Name = var.cvm_name,
      EnclaveID = substr(module.commons.enclave_id,0,8)
    },
    local.annotations
  )

  // Select the right cloud-init: with Remote Attestation support or default.
  user_data_base64 = base64gzip(module.commons.cloud_init_user_data)

  vpc_security_group_ids = [aws_security_group.default.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.cvm_disk_size_gb
    delete_on_termination = true
  }

  cpu_options {
    amd_sev_snp = var.cvm_platform.cpu == "snp" ? "enabled" : null // Enable AMD SEV-SNP
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
    ignore_changes = [user_data]
  }
}
