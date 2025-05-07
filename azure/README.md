# Azure Confidential VM

Terraform module to orchestrate Azure Confidential VM (CVM) instances.

## Authentication

Official documentation: 
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

Generate your Azure Client Id and Secret keys in Azure. Source an `.rc` file with the following environment variables:
```
export ARM_SUBSCRIPTION_ID=***
export ARM_TENANT_ID=***
export ARM_CLIENT_ID=***
export ARM_CLIENT_SECRET=***
```

## Module wrappers

Users of this Terraform module can create multiple similar resources by using for_each meta-argument within module block.

Users of Terragrunt can achieve similar results by using modules provided in the wrappers directory, if they prefer to reduce amount of configuration files.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.100.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.cvm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_az_resource_group_name"></a> [az\_resource\_group\_name](#input\_az\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_cvm_cloud_init"></a> [cvm\_cloud\_init](#input\_cvm\_cloud\_init) | n/a | `string` | n/a | yes |
| <a name="input_cvm_disk_size_gb"></a> [cvm\_disk\_size\_gb](#input\_cvm\_disk\_size\_gb) | n/a | `string` | `"30"` | no |
| <a name="input_cvm_name"></a> [cvm\_name](#input\_cvm\_name) | n/a | `string` | n/a | yes |
| <a name="input_cvm_os"></a> [cvm\_os](#input\_cvm\_os) | URN of the OS image | `string` | `"canonical:ubuntu-24_04-lts:cvm:latest"` | no |
| <a name="input_cvm_ports_open"></a> [cvm\_ports\_open](#input\_cvm\_ports\_open) | n/a | `list(string)` | `[]` | no |
| <a name="input_cvm_size"></a> [cvm\_size](#input\_cvm\_size) | Supported sizes are `Standard_DC*` or `Standard_EC*` series | `string` | `"Standard_DC2as_v5"` | no |
| <a name="input_cvm_ssh_enabled"></a> [cvm\_ssh\_enabled](#input\_cvm\_ssh\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_cvm_ssh_pubkey"></a> [cvm\_ssh\_pubkey](#input\_cvm\_ssh\_pubkey) | Path to the public key used for SSH connection | `string` | n/a | yes |
| <a name="input_cvm_username"></a> [cvm\_username](#input\_cvm\_username) | n/a | `string` | `"tower"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cvm-info"></a> [cvm-info](#output\_cvm-info) | Details of the running CVM instance(s) |
<!-- END_TF_DOCS -->