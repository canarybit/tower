output "cvm-info" {
  description = "Details of the running CVM instance(s)"
  value = <<-EOF

  Name:           ${var.cvm_name}
  Size/Family:    ${var.cvm_size} (Confidential) 
  OS:             ${var.cvm_os}
  Disk:           ${var.cvm_disk_size_gb} GB
  PublicIp:       ${aws_instance.amd-snp[0].public_ip}
  SshEnabled:     ${var.cvm_ssh_enabled}

  EOF
}