output "cvm-info" {
  description = "Details of the running CVM instance(s)"
  value = <<-EOF

  Name:           ${google_compute_instance.cvm.name}
  Size/Family:    ${google_compute_instance.cvm.machine_type} (Confidential) 
  OS:             ${element(local.cvm_running_os, length(local.cvm_running_os)-1)}
  Disk:           0 GB
  PublicIp:       ${google_compute_instance.cvm.network_interface.0.access_config.0.nat_ip}
  SshEnabled:     ${var.cvm_ssh_enabled}

  Secure Boot:    ${google_compute_instance.cvm.shielded_instance_config.0.enable_secure_boot}
  vTPM:           ${google_compute_instance.cvm.shielded_instance_config.0.enable_vtpm}

  EOF
}