resource "azurerm_network_security_group" "default" {
  name = var.cvm_name
  location = local.az_region
  resource_group_name = data.azurerm_resource_group.default.name
}

resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}

resource "azurerm_network_security_rule" "ssh" {
  count = var.cvm_ssh_enabled ? 1 : 0
  name = "${var.cvm_name}-ssh"
  direction = "Inbound"
  access = "Allow"
  priority = 100
  source_address_prefix = var.cvm_ssh_source_ip != null ? "${var.cvm_ssh_source_ip}/32" : "${chomp(data.http.my-public-ip.response_body)}/32"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_range = 22
  protocol = "Tcp"
  resource_group_name = data.azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name
}

resource "azurerm_network_security_rule" "custom" {
  count = var.cvm_ports_open != "" ? length(var.cvm_ports_open) : 0
  name = "${var.cvm_name}-in-${element(var.cvm_ports_open, count.index)}"
  direction = "Inbound"
  access = "Allow"
  priority = (200 + (tonumber(count.index)))
  source_address_prefix = "*"
  source_port_range = "*"
  destination_address_prefix = "*"
  destination_port_range = element(var.cvm_ports_open, count.index)
  protocol = "Tcp"
  resource_group_name = data.azurerm_resource_group.default.name
  network_security_group_name = azurerm_network_security_group.default.name
}
