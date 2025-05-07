terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 6.8.0"
    }
  }
}

provider "google" {}

// =====================
//  Confidential VM (CVM)
// =====================
module "confidential-vm" {
  source = "git@github.com:canarybit/tower-standard//gcp?ref=main"

  cvm_name = "my-confidential-vm"
  cvm_cloud_init = "../../commons/cloud-init.yml"
  cvm_ssh_enabled = true
}

// =====================
//  Print CVM info
// =====================
output "Confidential_VM_Info" {
  value = module.confidential-vm.cvm-info
}