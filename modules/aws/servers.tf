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

  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "null_resource" "attestation" {
  count = var.remote_attestation != null ? 1 : 0

  depends_on = [aws_instance.cvm]

  triggers = {
    instance_id = aws_instance.cvm.id
  }

  connection {
    type        = "ssh"
    user        = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey, ".pub"))
    host        = aws_instance.cvm.public_ip
    timeout     = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init'",
      "if command -v cloud-init >/dev/null 2>&1; then sudo timeout 20m cloud-init status --wait --long; else echo 'cloud-init is not installed; skipping wait'; fi",
      "sudo test -x /etc/canarybit/launch-cb-inspector-client || { echo 'Attestation launcher is missing; check cloud-init status and logs' >&2; exit 1; }",
      "echo 'Running attestation launcher'",
      "sudo timeout 10m /etc/canarybit/launch-cb-inspector-client",
      "echo 'Attestation launcher finished'",
    ]
  }
}
