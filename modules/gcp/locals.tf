locals {
  annotations = merge(var.cvm_annotations, {
    "canarybit" = "tower"
  })

  // CVM OS info
  cvm_running_os = split("/", google_compute_instance.cvm.boot_disk.0.initialize_params.0.image)

  // Map VM size with CPU type
  cvm_size_cpu_type_map = {
    TDX = ["c3"]
    SEV_SNP = ["n2d"]
  }
}