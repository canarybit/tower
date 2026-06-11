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
  type = object({
    environments = string
    cbinspector_url = optional(string, "https://api.inspector.confidentialcloud.io")
    cbclient_version = optional(string, "0.3.0")
    cbcli_version = optional(string, "0.2.5")
    signing_key = optional(string)
    custom_policy_file = optional(string)
    frequency = optional(string, "daily")
  })
  default = null

  validation {
    condition = contains(["snp", "tdx"], var.remote_attestation.environments)
    error_message = "The value has to be one of the following: ['snp', 'tdx']"
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
  description = "Custom Annotations in format \"<Namespace>\" = \"<Key>=<Value>\""
  type = map
  default = {}
}