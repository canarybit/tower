resource "azurerm_linux_virtual_machine" "cvm" {
  name = var.cvm_name
  resource_group_name = data.azurerm_resource_group.default.name
  location = data.azurerm_resource_group.default.location
  size = var.cvm_size
  user_data = base64encode(file(var.cvm_cloud_init))

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

  lifecycle {
    ignore_changes = [user_data]
  }
}
