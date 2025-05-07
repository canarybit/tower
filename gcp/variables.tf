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

///////////////////////
// DEFAULT
///////////////////////

variable "cvm_size" {
  // Official Docs: https://cloud.google.com/confidential-computing/confidential-vm/docs/supported-configurations
  description = "Supported sizes are N2D for AMD SNP or C3-standard for Intel TDX"
  type = string
  default = "n2d-standard-2"

  validation {
    condition = length(regexall("^[n2d,c3-standard]+", var.cvm_size)) > 0
    error_message = "Valid values are n2d-* or c3-standard-* series"
  }
}

variable "cvm_cpu_platform" {
  // All CPU platforms here: https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform
  description = "Supported CPU Platforms are ['AMD Milan','AMD Genoa'] for AMD SNP and ['sapphirerapids'] for Intel TDX"
  type = string
  default = "AMD Milan"
}

variable "cvm_os" {
  description = ""
  type = string
  default = "ubuntu-2404-lts-amd64"
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
  default = null
}