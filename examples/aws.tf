terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.20.0"
    }
  }
}

provider "aws" {}

// =====================
//  Tower Arguments
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

variable "n_of_cvm" {
  description = "Number of Confidential VMs to provision"
  type = number
  default = 1
}

// ========================
//  Confidential VM (CVM)
// ========================

module "confidential-vm" {
  source = "canarybit/tower/canarybit//modules/aws"
  cb_username = var.cb_username
  cb_password = var.cb_password

  // Confidential VM
  count = var.n_of_cvm
  cvm_name = "demo-cvm-${count.index}"
  cvm_ssh_enabled = true
  cvm_ssh_pubkey = "~/.ssh/id_rsa.pub"
  cvm_size = "c6a.xlarge"

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