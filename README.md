# Welcome to Tower

Tower is a security orchestration tool to automatically provision, control and maintain your Confidential VM instances.

It integrates with a wide list of Cloud Service Providers (CSPs), Private or Bare-metal infrastructure to offer full governance of the resources defining your Trusted Execution Environment (TEE).

It fully implements Infrastructure as Code (IaC) and SecDevOps methodologies to provide integrity and the highest security standards to your workloads runtime.

## Licences

### Standard (FREE)

The Standard version contains the Terraform/OpenTofu configurations for deploying Confidential VMs in **Public Clouds**.

Currently, the following Cloud providers are supported:

- [Aws](/aws)
- [Azure](/azure)
- [Gcp](/aws)

### Premium

The Premium version contains the Terraform configurations for deploying Confidential VMs **on-premise** and for **bare-metal** setups.

Currently, the following virtualisation plaftorms are supported:

- Libvirt/KVM
- Proxmox

Contact us at hi@canarybit.eu to get access to the Premium version.

## General Requirements

- [Terraform](https://developer.hashicorp.com/terraform) or [OpenTofu](https://opentofu.org/docs/intro/install/) installed;
- Credentials to access your favourite Cloud Service Provider;
- A SSH RSA key to access Confidential VM istances.