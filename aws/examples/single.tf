terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

provider "aws" {}

// =====================
//  Confidential VM (CVM)
// =====================
module "confidential-vm" {
  source = "git@github.com:canarybit/tower-standard//aws?ref=main"
  
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