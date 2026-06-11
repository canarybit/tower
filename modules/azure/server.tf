resource "azurerm_linux_virtual_machine" "cvm" {
  name = var.cvm_name
  resource_group_name = data.azurerm_resource_group.default.name
  location = local.az_region
  size = var.cvm_size
  tags = local.annotations

  // Select the right cloud-init: default or with Remote Attestation support.
  user_data = var.remote_attestation != null ? base64encode(templatefile("${path.module}/../../cloud-init/attested.yml",
      {
        HOSTNAME                = var.cvm_name
        USERNAME                = var.cvm_username
        SSH_PUBKEY              = file(var.cvm_ssh_pubkey)
        // CanaryBit Remote Attestation
        CBINSPECTOR_URL         = var.remote_attestation.cbinspector_url
        CBCLIENT_V              = var.remote_attestation.cbclient_version
        CBCLI_V                 = var.remote_attestation.cbcli_version
        ENVIRONMENTS            = var.remote_attestation.environments
        CUSTOM_POLICY_OPT       = var.remote_attestation.custom_policy_file != null ? "--policy /etc/canarybit/custom-policy.rego" : ""
        CUSTOM_POLICY           = var.remote_attestation.custom_policy_file != null ? indent(6,file(var.remote_attestation.custom_policy_file)) : ""
        FREQUENCY               = var.remote_attestation.frequency
        CBCLIENT_ANNOTATIONS    = join(",", formatlist("%s=%s", keys(local.annotations), values(local.annotations)))
      }
    )) : base64encode(templatefile("${path.module}/../../cloud-init/default.yml",
      {
        HOSTNAME           = var.cvm_name       
        USERNAME           = var.cvm_username
        SSH_PUBKEY         = file(var.cvm_ssh_pubkey)
      }
    )
  )

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
    content = "CB_TOKENS='${data.http.cblogin.*.response_body[0]}'"
  }
  provisioner "file" {
    destination = "/home/${var.cvm_username}/signing-key.pem"
    content = tls_private_key.rsa-4096.private_key_pem_pkcs8
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo /etc/canarybit/launch-cbclient",
    ]
  }

  lifecycle {
    ignore_changes = [user_data]
  }
}
