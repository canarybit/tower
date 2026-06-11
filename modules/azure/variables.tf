///////////////////////
// REQUIRED
///////////////////////

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

variable "cvm_name" {
  description = "Confidential VM name"
  type = string
}

variable "cvm_ssh_pubkey" { 
  description = "Path to the public key used for SSH connection"
  type = string
}

variable "cvm_size" {
  description = "Supported sizes are `Standard_DC*` or `Standard_EC*` series"
  type = string

  validation {
    condition = length(regexall("^Standard_[D,E]C+", var.cvm_size)) > 0
    error_message = "Valid values are Standard_DC* or Standard_EC* series"
  }
}

variable "az_resource_group_name" {
  description = "Azure Resource Group Name"
  type = string
}

variable "remote_attestation" {
  description = "Enable CanaryBit Remote Attestation"
  type = object({
    environments = string
    cbinspector_url = optional(string, "https://api.inspector.confidentialcloud.io")
    cbclient_version = optional(string, "0.3.2")
    cbcli_version = optional(string, "0.2.5")
    signing_key = optional(string)
    custom_policy_file = optional(string)
    frequency = optional(string, "daily")
  })

  validation {
    condition = contains(["snp", "tdx"], var.remote_attestation.environments)
    error_message = "The value has to be one of the following: ['snp', 'tdx']"
  }
}

///////////////////////
// DEFAULTS
///////////////////////

variable "az_region" {
  description = "Azure Region. Defaults to the AZ Resource Group location."
  type = string
  default = null
}

variable "cvm_os" {
  description = "URN of the OS image"
  type = string
  default = "canonical:ubuntu-24_04-lts:cvm:latest"
}

variable "cvm_username" {
  description = "CVM Username for SSH login"
  type = string
  default = "tower"
}

variable "cvm_disk_size_gb" {
  description = "CVM Disk size"
  type = string
  default = "30"
}

variable "cvm_ports_open" {
  description = "List of CVM open network ports"
  type = list(string)
  default = []
}

variable "cvm_ssh_enabled" {
  description = "Enable/Disable SSH connection"
  type = bool
  default = true
}

variable "cvm_ssh_source_ip" {
  description = "Source IP for SSH connection"
  type = string
  default = null
}

variable "cvm_annotations" {
  description = "Custom annotations in \"<Key>=<Value>\" format"
  type = map
  default = {}
}