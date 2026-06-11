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
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 7.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.custom](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_instance.cvm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance) | resource |
| [google_compute_network.cvm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [local_sensitive_file.signing-key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [null_resource.signing-key-fingerprint](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.rsa-4096](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [http_http.cblogin](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.my-public-ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [local_file.signing-key-fingerprint](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cb_password"></a> [cb\_password](#input\_cb\_password) | CanaryBit password | `string` | n/a | yes |
| <a name="input_cb_username"></a> [cb\_username](#input\_cb\_username) | CanaryBit username | `string` | n/a | yes |
| <a name="input_cvm_annotations"></a> [cvm\_annotations](#input\_cvm\_annotations) | Custom annotations in "<Key>=<Value>" format | `map` | `{}` | no |
| <a name="input_cvm_disk_size_gb"></a> [cvm\_disk\_size\_gb](#input\_cvm\_disk\_size\_gb) | CVM Disk size | `string` | `"0"` | no |
| <a name="input_cvm_name"></a> [cvm\_name](#input\_cvm\_name) | Confidential VM name | `string` | n/a | yes |
| <a name="input_cvm_os"></a> [cvm\_os](#input\_cvm\_os) | URI of the OS image | `string` | `"ubuntu-2404-lts-amd64"` | no |
| <a name="input_cvm_ports_open"></a> [cvm\_ports\_open](#input\_cvm\_ports\_open) | List of CVM open network ports | `list(string)` | `[]` | no |
| <a name="input_cvm_size"></a> [cvm\_size](#input\_cvm\_size) | Supported VM sizes: N2D for AMD SNP or C3 for Intel | `string` | n/a | yes |
| <a name="input_cvm_ssh_enabled"></a> [cvm\_ssh\_enabled](#input\_cvm\_ssh\_enabled) | Enable/Disable SSH connection | `bool` | `true` | no |
| <a name="input_cvm_ssh_pubkey"></a> [cvm\_ssh\_pubkey](#input\_cvm\_ssh\_pubkey) | Path to the public key used for SSH connection | `string` | n/a | yes |
| <a name="input_cvm_ssh_source_ip"></a> [cvm\_ssh\_source\_ip](#input\_cvm\_ssh\_source\_ip) | Source IP for SSH connection | `string` | `null` | no |
| <a name="input_cvm_username"></a> [cvm\_username](#input\_cvm\_username) | CVM Username for SSH login | `string` | `"tower"` | no |
| <a name="input_remote_attestation"></a> [remote\_attestation](#input\_remote\_attestation) | Enable CanaryBit Remote Attestation | <pre>object({<br/>    environments = string<br/>    cbinspector_url = optional(string, "https://api.inspector.confidentialcloud.io")<br/>    cbclient_version = optional(string, "0.3.2")<br/>    cbcli_version = optional(string, "0.2.5")<br/>    signing_key = optional(string)<br/>    custom_policy_file = optional(string)<br/>    frequency = optional(string, "daily")<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud-init"></a> [cloud-init](#output\_cloud-init) | The cloud-init configuration of the running CVM instance(s) |
| <a name="output_cvm-info"></a> [cvm-info](#output\_cvm-info) | Details of the running CVM instance(s) |
<!-- END_TF_DOCS -->