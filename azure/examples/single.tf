terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 4.0.1"
    }
  }
}

provider "azurerm" {
  features {}
}

// =====================
//  Confidential VM (CVM)
// =====================
module "confidential-vm" {
  source = "git@github.com:canarybit/tower-standard//azure?ref=main"

  az_resource_group_name = "my-resource-group"
  
  cvm_name = "my-confidential-vm"
  cvm_cloud_init = "../../commons/cloud-init.yml"
  cvm_ssh_enabled = true
  cvm_ssh_pubkey = "~/.ssh/id_rsa.pub"
}

// =====================
//  Print CVM info
// =====================
output "Confidential_VM_Info" {
  value = module.confidential-vm.cvm-info
}