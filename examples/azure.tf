terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.0.1"
    }
  }
}

provider "azurerm" {
  features {}
}

// =====================
// Tower Arguments
// =====================

variable "cb_username" {
  description = "CanaryBit username"
  type = string
  sensitive = true
}

variable "cb_password" {
  description = "CanaryBit password"
  type = string
  sensitive = true
}

variable "allow_ssh" {
  description = "Allow/Deny SSH connection"
  type = bool
  default = true
}

variable "n_of_cvm" {
  description = "Number of Confidential VMs to provision"
  type = number
  default = 1
}

// ========================
//  Confidential VM (CVM)
// ========================

module "confidential-vm" {
  source = "canarybit/tower/canarybit//modules/azure"
  cb_username = var.cb_username
  cb_password = var.cb_password

  // Azure Info
  az_resource_group_name = "continuoustesting1932"

  // Confidential VM
  count = var.n_of_cvm
  cvm_name = "demo-cvm-${count.index}"
  cvm_ssh_enabled = var.allow_ssh
  cvm_ssh_pubkey = "~/.ssh/id_rsa.pub"
  cvm_size = "Standard_DC2as_v5"
  
  // Remote Attestation
  remote_attestation = {
    environments = "snp"
    frequency = "daily"
    custom_policy_file = "./my-policy.rego"
  }
}

// ========================
//  Print CVM info
// ========================

output "cvm-info" {
  value = module.confidential-vm.*.cvm-info
}
