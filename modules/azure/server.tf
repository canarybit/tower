resource "azurerm_linux_virtual_machine" "cvm" {
  name = var.cvm_name
  resource_group_name = data.azurerm_resource_group.default.name
  location = local.az_region
  size = var.cvm_size
  tags = local.annotations // TODO: add enclave id here?

  // Select the right cloud-init: default or with Remote Attestation support.
  user_data = base64encode(module.commons.cloud_init_user_data)

  # The required AZ approach to add a VM user in addition to cloud-init config
  admin_username = var.cvm_username
  admin_ssh_key {
    username = var.cvm_username
    public_key = file(var.cvm_ssh_pubkey)
  }

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.default.id
  ]

  vtpm_enabled = true
  secure_boot_enabled = true

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
    security_encryption_type = "DiskWithVMGuestState"
    disk_size_gb = var.cvm_disk_size_gb
  }

  source_image_reference {
    publisher = local.cvm_os_urn[0]
    offer = local.cvm_os_urn[1]
    sku = local.cvm_os_urn[2]
    version = local.cvm_os_urn[3]
  }

  # Enable ssh connection, create a file containing the cbtoken and launch the script
  connection {
    type = "ssh"
    user = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey,".pub"))
    host = self.public_ip_address
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/tokens"
    content = "CB_TOKENS='${module.commons.cb_tokens}'"
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/signing-key.pem"
    content = module.commons.signing_key_pem
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo /etc/canarybit/launch-cb-inspector-client",
    ]
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}
