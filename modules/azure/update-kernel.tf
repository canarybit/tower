resource "null_resource" "update_kernel" {
  depends_on = [azurerm_linux_virtual_machine.cvm]

  triggers = {
    instance_id = azurerm_linux_virtual_machine.cvm.id
  }

  connection {
    type        = "ssh"
    user        = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey, ".pub"))
    host        = azurerm_linux_virtual_machine.cvm.public_ip_address
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
