resource "google_compute_network" "cvm" {
  name = "cvm-network"
}

resource "google_compute_firewall" "ssh" {
  count = var.cvm_ssh_enabled ? 1 : 0
  network = google_compute_network.cvm.name
  name = var.cvm_name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
      protocol = "tcp"
      ports = [22]
  }
}

resource "google_compute_firewall" "rules" {
  count = length(var.cvm_ports_open) > 0 ? 1 : 0
  network = google_compute_network.cvm.name
  name = "rules"
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
      protocol = "tcp"
      ports = var.cvm_ports_open
  }
}
