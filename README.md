# Welcome to Tower

[Tower](https://www.canarybit.eu/confidential-cloud-tower/) is a security orchestration tool to automatically provision, control and maintain Confidential VM instances. 
Tower integrates with a wide list of Cloud Service Providers (CSPs), Private or Bare-metal infrastructure to offer full governance of the resources defining your Trusted Execution Environment (TEE).
It implements Infrastructure as Code (IaC) and SecDevOps methodologies to provide integrity and the highest security standards to your workloads runtime.

[Inspector](https://www.canarybit.eu/confidential-cloud-inspector/) supports remote attestation of deployed confidential VMs. Contact us at hi@canarybit.eu to learn more about CanaryBit's solution for remote attestation of confidential VMs.

## Licences

### Standard (Apache-2.0)
The Standard version contains the Terraform/OpenTofu configurations for deploying Confidential VMs in **Public Clouds**. 
Currently Tower supports the following platforms and public cloud providers:

| Cloud Provider/TEE Platform    | AMD SEV-SNP | Intel TDX |
| -------- | ------- |------- |
| [AWS](/aws)        | yes    | upcoming    |
| [Azure](/azure)        | yes    | upcoming    |
| [GCP](/gcp)        | yes    | yes    |

### Premium
The Premium version contains the Terraform configurations for deploying Confidential VMs **on-premise** and for **bare-metal** setups.
Currently Tower supports the following virtualisation plaftorms:

- [Libvirt/Qemu/KVM](https://libvirt.org/)
- [Proxmox](https://www.proxmox.com/)
- [VMware vSphere](https://www.vmware.com/products/cloud-infrastructure/vsphere)

Contact us at hi@canarybit.eu if you want to use Tower to deploy confidential VMs in on-prem deployments (that requires the Premium version).

## General Requirements

- [Terraform](https://developer.hashicorp.com/terraform) or [OpenTofu](https://opentofu.org/docs/intro/install/) installed;
- Credentials to access your favourite Cloud Service Provider;
- A SSH RSA key to access Confidential VM instances.
