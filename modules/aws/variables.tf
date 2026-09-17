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
  description = <<EOT
    Supported sizes are:
      - AMD SNP: M6a, C6a, R6a
      - Intel TDX: M7i, M7i-flex
  EOT
  type = string

  validation {
    condition = length(regex("(^((m6a|c6a|r6a|m7i|m7i^-flex)))(\\.)([a-z0-9]+)", var.cvm_size)) > 0
    error_message = "Supported sizes are M6a, C6a, R6a for AMD SNP and nd M7i, M7i-flex for Intel TDX"
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
  description = "AMI of the OS image"
  type = string
  default = "ami-09040d770ffe2224f" // Canonical, Ubuntu, 24.04 LTS, amd64 noble image build on 2024-04-23
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
  type = map(any)
  default = {}
}
