# GCP Confidential VM

Terraform module to orchestrate GCP Confidential VM (CVM) instances.

## Authentication

Official documentation
https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication

Once `gcloud` is installed on your machine, run:
```
$ gcloud auth application-default login
```
and export the following environment variables:
```
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"
export GOOGLE_PROJECT=***
export GOOGLE_ZONE=***
```

## Module wrappers

Users of this Terraform module can create multiple similar resources by using for_each meta-argument within module block.

Users of Terragrunt can achieve similar results by using modules provided in the wrappers directory, if they prefer to reduce amount of configuration files.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.rules](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.cvm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.cvm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cvm_cloud_init"></a> [cvm\_cloud\_init](#input\_cvm\_cloud\_init) | n/a | `string` | n/a | yes |
| <a name="input_cvm_cpu_platform"></a> [cvm\_cpu\_platform](#input\_cvm\_cpu\_platform) | Supported CPU Platforms are ['AMD Milan','AMD Genoa'] for AMD SNP and ['sapphirerapids'] for Intel TDX | `string` | `"AMD Milan"` | no |
| <a name="input_cvm_disk_size_gb"></a> [cvm\_disk\_size\_gb](#input\_cvm\_disk\_size\_gb) | n/a | `string` | `"30"` | no |
| <a name="input_cvm_name"></a> [cvm\_name](#input\_cvm\_name) | n/a | `string` | n/a | yes |
| <a name="input_cvm_os"></a> [cvm\_os](#input\_cvm\_os) | n/a | `string` | `"ubuntu-2404-lts-amd64"` | no |
| <a name="input_cvm_ports_open"></a> [cvm\_ports\_open](#input\_cvm\_ports\_open) | n/a | `list(string)` | `[]` | no |
| <a name="input_cvm_size"></a> [cvm\_size](#input\_cvm\_size) | Supported sizes are N2D for AMD SNP or C3-standard for Intel TDX | `string` | `"n2d-standard-2"` | no |
| <a name="input_cvm_ssh_enabled"></a> [cvm\_ssh\_enabled](#input\_cvm\_ssh\_enabled) | n/a | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cvm-info"></a> [cvm-info](#output\_cvm-info) | Details of the running CVM instance(s) |
<!-- END_TF_DOCS -->