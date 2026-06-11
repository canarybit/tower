locals {
  annotations = merge(var.cvm_annotations, {
    "canarybit" = "tower"
  })
}