locals {
  annotations = merge(var.cvm_annotations, {
    "canarybit" = "tower"
  })

  // Split the URN references from cvm_os variable to build the source image reference
  cvm_os_urn = split(":", var.cvm_os)

  az_region = var.az_region != null ? var.az_region : data.azurerm_resource_group.default.location
}