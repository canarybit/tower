///////////////////////
// REQUIRED
///////////////////////

variable "cvm_name" {
  description = ""
  type = string
}

variable "cvm_cloud_init" {
  description = ""
  type = string  
}

// Azure specific

variable "az_resource_group_name" {
  description = ""
  type = string
}

variable "cvm_ssh_pubkey" { 
  description = "Path to the public key used for SSH connection"
  type = string
}

///////////////////////
// DEFAULT
///////////////////////

variable "cvm_size" {
  description = "Supported sizes are `Standard_DC*` or `Standard_EC*` series"
  type = string
  default = "Standard_DC2as_v5"

  validation {
    # Check if it's a supported size
    condition = length(regexall("^Standard_[D,E]C+", var.cvm_size)) > 0
    error_message = "Valid values are Standard_DC* or Standard_EC* series"
  }
}

variable "cvm_os" {
  description = "URN of the OS image"
  type = string
  default = "canonical:ubuntu-24_04-lts:cvm:latest"
}

variable "cvm_username" {
  description = ""
  type = string
  default = "tower"
}

variable "cvm_disk_size_gb" {
  description = ""
  type = string
  default = "30"
}

variable "cvm_ports_open" {
  description = ""
  type = list(string)
  default = []
}

variable "cvm_ssh_enabled" {
  description = ""
  type = bool
  default = null
}