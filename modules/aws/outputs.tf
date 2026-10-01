output "cvm-info" {
  description = "Details of the running CVM instance(s)"
  value = <<EOF

  Name:           ${var.cvm_name}
  Size/Family:    ${var.cvm_size} (Confidential)
  OS:             ${var.cvm_os}
  Disk:           ${var.cvm_disk_size_gb} GB
  Public IP:      ${aws_instance.cvm.public_ip}
  SSH Enabled:    ${var.cvm_ssh_enabled}
  Username:       ${var.cvm_username}

  EnclaveID / Signing Key Fingerprint:
    ${module.commons.enclave_id}

  EOF
}
