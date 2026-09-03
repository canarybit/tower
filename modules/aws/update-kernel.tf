resource "null_resource" "update_kernel" {
  depends_on = [aws_instance.cvm]

  triggers = {
    instance_id = aws_instance.cvm.id
  }

  connection {
    type        = "ssh"
    user        = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey, ".pub"))
    host        = aws_instance.cvm.public_ip
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
