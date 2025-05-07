locals {
  // Split the URN references from cvm_os variable to build the source image reference
  cvm_os_urn = split(":", var.cvm_os)
}