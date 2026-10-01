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

variable "cvm_platform" {
  description = <<-EOT
    Type of Confidential CPU hardware platform
    cvm_platform = {
      cpu     - CPU hardware type: ['snp', 'tdx']
    }
  EOT

  type = object({
    type     = string
  })

  validation {
    condition     = contains(["snp", "tdx"], var.cvm_platform.cpu)
    error_message = "The value has to be one of the following: ['snp', 'tdx']"
  }
}

variable "cvm_size" {
  description = "Supported VM sizes: N2D for AMD SNP or C3 for Intel"
  type = string

  validation {
    condition = length(regexall("^[n2d,c3]+", var.cvm_size)) > 0
    error_message = "ERROR - Invalid VM size"
  }
}

///////////////////////
// DEFAULTS
///////////////////////

variable "remote_attestation" {
  description = "Enable CanaryBit Remote Attestation"
  type = any
}

variable "cloud_init" {
  description = "Custom cloud-init configuration"
  type = object({
    custom_path = optional(string)
    extra_args  = optional(map(any), {})
  })
  default = {}

  validation {
    condition     = !(var.cloud_init.custom_path == null && length(var.cloud_init.extra_args) > 0)
    error_message = "A custom_path is required when using extra_args in cloud_init"
  }
}

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
