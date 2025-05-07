locals {
  cvm_running_os = split("/", google_compute_instance.cvm.boot_disk.0.initialize_params.0.image)
}