# CanaryBit Tower  

CanaryBit [Tower](https://www.canarybit.eu/confidential-cloud-tower/) is a security orchestration tool to provision, control and maintain Confidential VM instances.
Tower integrates with a long list of Cloud Service Providers (CSPs), private and bare-metal infrastructure to provide 
governance of the resources defining your Trusted Execution Environment (TEE).

It implements Infrastructure-as-Code (IaC) and SecDevOps best-practices to provide integrity and state-of-the-art security to your workloads runtime.

## Requirements

- [Terraform](https://developer.hashicorp.com/terraform) or [OpenTofu](https://opentofu.org/docs/intro/install/) installed;
- Credentials to access your Infrastructure provider (either Public Cloud or On-prem);
- A CanaryBit account. (*New user? [Create an account.](https://canarybit-production.auth.eu-north-1.amazoncognito.com/login?client_id=54g4h9tpulnnkmhivgn5nipjki&redirect_uri=https://docs.confidentialcloud.io/&response_type=code&scope=email+openid+profile)*)

## Documentation
For setup instructions, API references, and usage examples, read the [CanaryBit Tower Technical Documentation](https://docs.confidentialcloud.io/tower/).

## Contributing

Contributions are welcome! Please check the [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to get started.

## Licences

CanaryBit Tower is a Freemium service: basic features are free for Public Cloud setups while additional features, such as Remote Attestation and On-prem support, are offered via a paid subscription.

### Standard

The [Apache-2.0 License](LICENSE) *free* version contains the Terraform/OpenTofu configurations for deploying Confidential VMs in **Public Clouds**.

Currently, CanaryBit Tower supports the following platforms and public cloud providers:

| Cloud Platform          | AMD SEV-SNP | Intel TDX   |
|-------------------------| ----------- |------------ |
| [AWS](/modules/aws)     | yes         | upcoming    |
| [Azure](/modules/azure) | yes         | yes         |
| [GCP](/modules/gcp)     | yes         | yes         |

### Premium

The Premium version contains the Terraform configurations for deploying Confidential VMs **on-premise** and for **bare-metal** setups.

Currently, Tower supports the following on-prem, virtualisation platforms:

- [Libvirt/Qemu](https://libvirt.org/)
- [Proxmox v9.1+](https://www.proxmox.com/)
- [VMware vSphere v9.0+](https://www.vmware.com/products/cloud-infrastructure/vsphere)

## Integrations

- **Galaxy server**: Support for the [Galaxy project](https://github.com/galaxyproject) for data-intensive computation.

## Contacts

Reach us out at [hi@canarybit.eu](mailto:hi@canarybit.eu) for more information.

/ The CanaryBit Team