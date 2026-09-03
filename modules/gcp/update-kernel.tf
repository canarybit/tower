resource "null_resource" "update_kernel" {
  depends_on = [google_compute_instance.cvm]

  triggers = {
    instance_id = google_compute_instance.cvm.id
  }

  connection {
    type        = "ssh"
    user        = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey, ".pub"))
    host        = google_compute_instance.cvm.network_interface[0].access_config[0].nat_ip
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo env DEBIAN_FRONTEND=noninteractive apt-get update",
      "sudo env DEBIAN_FRONTEND=noninteractive apt-get install --yes --install-recommends linux-generic",
      "if [ -f /var/run/reboot-required ]; then sudo shutdown -r +1 'Kernel update completed'; fi",
    ]
  }
}
