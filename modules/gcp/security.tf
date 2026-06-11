resource "google_compute_network" "cvm" {
  name = "cvm-network"
}

resource "google_compute_firewall" "ssh" {
  count = var.cvm_ssh_enabled ? 1 : 0
  network = google_compute_network.cvm.name
  name = var.cvm_name
  direction = "INGRESS"
  source_ranges = var.cvm_ssh_source_ip != null ? ["${var.cvm_ssh_source_ip}/32"] : ["${chomp(data.http.my-public-ip.response_body)}/32"]
  allow {
      protocol = "tcp"
      ports = [22]
  }
}

resource "google_compute_firewall" "custom" {
  count = length(var.cvm_ports_open) > 0 ? 1 : 0
  network = google_compute_network.cvm.name
  name = var.cvm_name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
      protocol = "tcp"
      ports = var.cvm_ports_open
  }
}
