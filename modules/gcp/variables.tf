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
  description = "Supported VM sizes: N2D for AMD SNP or C3 for Intel"
  type = string
  
  validation {
    condition = length(regexall("^[n2d,c3]+", var.cvm_size)) > 0
    error_message = "ERROR - Invalid VM size"
  }
}

variable "remote_attestation" {
  description = "Enable CanaryBit Remote Attestation"
  type = object({
    environments = string
    cb_inspector_url = optional(string, "https://api.inspector.confidentialcloud.io")
    cb_inspector_client_version = optional(string, "0.1.0")
    cbcli_version = optional(string, "0.2.6")
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

variable "cvm_os" {
  description = "URI of the OS image"
  type = string
  default = "ubuntu-2404-lts-amd64"
}

variable "cvm_username" {
  description = "CVM Username for SSH login"
  type = string
  default = "tower"
}

variable "cvm_disk_size_gb" {
  description = "CVM Disk size"
  type = string
  default = "0"
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

variable "kernel_update_enabled" {
  description = "Enable the automatic kernel update after the CVM is created"
  type = bool
  default = false
}

variable "kernel_version" {
  description = "Optional kernel package version. If unset, the latest available kernel is installed."
  type = string
  default = null
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
