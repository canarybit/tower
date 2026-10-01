data "azurerm_resource_group" "default" {
  name = var.az_resource_group_name
}

data "http" "my-public-ip" {
  url = "https://ipv4.icanhazip.com"
}
