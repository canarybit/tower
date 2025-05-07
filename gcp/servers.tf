resource "google_compute_instance" "cvm" {
  name = var.cvm_name
  machine_type = var.cvm_size

  boot_disk {
    initialize_params {
      image = var.cvm_os
    }
  }

  network_interface {
    network = google_compute_network.cvm.id
    access_config {
      // Include this section to assign the VM an external IP address
    }
  }

  metadata = {
    // Attention: it's user-data with "-" and not "_" 
    user-data = file(var.cvm_cloud_init)
  }

  shielded_instance_config {
    enable_secure_boot = true
    enable_vtpm = true
    enable_integrity_monitoring = true
  }

  allow_stopping_for_update = false

  min_cpu_platform = var.cvm_cpu_platform

  confidential_instance_config {
      enable_confidential_compute = true
      confidential_instance_type = strcontains(var.cvm_cpu_platform, "AMD") ? "SEV_SNP" : "TDX"
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }

}