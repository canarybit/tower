module "commons" {
  source = "../../../tower-commons/modules/commons"

  cb_username = var.cb_username
  cb_password = var.cb_password

  cvm_name     = var.cvm_name
  cvm_username = var.cvm_username
  cvm_platform = var.cvm_cpu_platform.type

  cvm_annotations = var.cvm_annotations

  remote_attestation = var.remote_attestation

  cloud_init_packages = []

  cloud_init      = var.cloud_init
  use_provisioner = true
}
