///////////////////////
// AMD SNP
///////////////////////

resource "aws_instance" "amd-snp" {
  count = strcontains(var.cvm_size,"m6a") || strcontains(var.cvm_size,"c6a") || strcontains(var.cvm_size,"r6a") ? 1 : 0
  tags = {
    Name = var.cvm_name
  }

  ami = var.cvm_os
  instance_type = var.cvm_size

  user_data = var.cvm_cloud_init != null ? base64encode(file(var.cvm_cloud_init)) : null

  vpc_security_group_ids = [aws_security_group.default.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.cvm_disk_size_gb
    delete_on_termination = true
  }

  cpu_options {
    amd_sev_snp = "enabled" // Enables AMD SEV-SNP
  }

}

///////////////////////
// INTEL TDX
///////////////////////

resource "aws_instance" "intel-tdx" {
  count = strcontains(var.cvm_size,"m7i") || strcontains(var.cvm_size,"m7i-flex") ? 1 : 0
  tags = {
    Name = var.cvm_name
  }

  ami = var.cvm_os
  instance_type = var.cvm_size

  user_data = base64encode(file(var.cvm_cloud_init))

  vpc_security_group_ids = [aws_security_group.default.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = var.cvm_disk_size_gb
    delete_on_termination = true
  }
}