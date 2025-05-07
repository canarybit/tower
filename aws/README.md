# Aws Confidential VM

Terraform module to orchestrate AWS Confidential VM (CVM) instances.

## Authentication

Official documentation: 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs#provider-configuration 

Generate your AWS Access and Secret keys in AWS. Source an `.rc` file with the following environment variables:
```
export AWS_ACCESS_KEY_ID=***
export AWS_SECRET_ACCESS_KEY=***
export AWS_DEFAULT_REGION=***
```

## Module wrappers

Users of this Terraform module can create multiple similar resources by using for_each meta-argument within module block.

Users of Terragrunt can achieve similar results by using modules provided in the wrappers directory, if they prefer to reduce amount of configuration files.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.amd-snp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.intel-tdx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress-ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cvm_cloud_init"></a> [cvm\_cloud\_init](#input\_cvm\_cloud\_init) | n/a | `string` | n/a | yes |
| <a name="input_cvm_disk_size_gb"></a> [cvm\_disk\_size\_gb](#input\_cvm\_disk\_size\_gb) | n/a | `string` | `"30"` | no |
| <a name="input_cvm_name"></a> [cvm\_name](#input\_cvm\_name) | n/a | `string` | n/a | yes |
| <a name="input_cvm_os"></a> [cvm\_os](#input\_cvm\_os) | AMI of the OS image | `string` | `"ami-09040d770ffe2224f"` | no |
| <a name="input_cvm_ports_open"></a> [cvm\_ports\_open](#input\_cvm\_ports\_open) | n/a | `list(string)` | `[]` | no |
| <a name="input_cvm_size"></a> [cvm\_size](#input\_cvm\_size) | Supported sizes are:<br/>      - AMD SNP: M6a, C6a, R6a<br/>      - Intel TDX: M7i, M7i-flex | `string` | `"c6a.xlarge"` | no |
| <a name="input_cvm_ssh_enabled"></a> [cvm\_ssh\_enabled](#input\_cvm\_ssh\_enabled) | n/a | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cvm-info"></a> [cvm-info](#output\_cvm-info) | Details of the running CVM instance(s) |
<!-- END_TF_DOCS -->