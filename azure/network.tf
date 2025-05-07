resource "azurerm_virtual_network" "default" {
  name = var.cvm_name
  resource_group_name = data.azurerm_resource_group.default.name
  location = data.azurerm_resource_group.default.location
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name = var.cvm_name
  resource_group_name = data.azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "default" {
  name = var.cvm_name
  resource_group_name = data.azurerm_resource_group.default.name
  location = data.azurerm_resource_group.default.location
  allocation_method = "Static"
}

resource "azurerm_network_interface" "default" {
  name = var.cvm_name
  location = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.default.id
  }
}