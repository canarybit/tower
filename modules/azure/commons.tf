module "commons" {
  source = "https://canarybit-public-binaries.s3.eu-west-1.amazonaws.com/tower-commons/v0.1.0/tower-commons.zip"

  cb_username = var.cb_username
  cb_password = var.cb_password

  cvm_name     = var.cvm_name
  cvm_username = var.cvm_username
  cvm_platform = var.cvm_platform.cpu

  cvm_annotations = var.cvm_annotations

  remote_attestation = var.remote_attestation

  cloud_init_packages = []

  cloud_init = var.cloud_init
  use_provisioner = true
}
