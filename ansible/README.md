# Kernel Update

Kernel updates and post-reboot attestation are managed by `kernel-update.yml` for all cloud providers.

Terraform creates the VM and uploads the attestation files. Run Ansible after Terraform completes.

Supported operating-system families: Ubuntu/Debian, RHEL-family (RHEL, Rocky, Alma, CentOS), and SUSE-family (SLES, openSUSE).

## Requirements

- Ansible on the machine running the playbook

## Inventory

Create an inventory containing the VM address:

```ini
[kernel_targets]
vm ansible_host=<PUBLIC_IP>
```

## Variables

| Variable | Default | Description |
|---|---|---|
| `kernel_version` | empty | Empty = update to the latest kernel. Set a value to pin that specific kernel (format per OS below). The pinned version must be newer than the currently running kernel — the playbook refuses to downgrade or reinstall the same version. |
| `kernel_flavor` | `generic` (Ubuntu) / `default` (SUSE) | Kernel flavor, e.g. `azure`, `azure-fde`, `aws`, `gcp`. Not used on RHEL. |
| `kernel_extra_packages` | `[]` | Extra packages to install alongside a pinned kernel (Ubuntu/Debian only). |
| `reboot_after_update` | `true` | Reboot when the running kernel needs to change. |
| `run_attestation` | | Set to `true` to run attestation after the reboot. |

## Latest kernel and attestation

When `kernel_version` is not set, the playbook updates to the latest kernel available in the VM's repositories.

```bash
ansible-playbook -i inventory.ini kernel-update.yml \
  -u <CVM_USERNAME> \
  --private-key /path/to/id_rsa \
  -e run_attestation=true
```

## Specific kernel version

When `kernel_version` is set, the playbook installs only that kernel, makes it the default boot entry, reboots into it, and verifies the running kernel matches. The requested version must be newer than what's currently running — the play fails immediately, before any package changes, if it isn't.

```bash
ansible-playbook -i inventory.ini kernel-update.yml \
  -u <CVM_USERNAME> \
  --private-key /path/to/id_rsa \
  -e kernel_version=<PACKAGE_VERSION> \
  -e run_attestation=true
```

`<PACKAGE_VERSION>` format depends on the OS:

| OS family | `kernel_version` format | Example |
|---|---|---|
| Ubuntu/Debian | `<version>-<abi>` (flavor is set separately) | `6.17.0-1018` with `-e kernel_flavor=azure` → `6.17.0-1018-azure` |
| RHEL-family | package version without arch | `5.14.0-362.8.1.el9_3` |
| SUSE-family | `kernel-default` package version | `5.14.21-150500.55.65.1` |

Examples:

```bash
# Ubuntu on Azure, plain kernel
-e kernel_version=6.17.0-1018 -e kernel_flavor=azure

# Ubuntu on Azure, confidential VM / disk-encrypted (UKI) kernel
-e kernel_version=6.17.0-1022 -e kernel_flavor=azure-fde

# RHEL
-e kernel_version=5.14.0-687.13.1.el9_8

# SUSE
-e kernel_version=5.14.21-150500.55.65.1
```

## Behavior

- **No `kernel_version`:** updates to the latest kernel. On RHEL this runs a full package update. Reboots only if the OS reports a reboot is required.
- **`kernel_version` set:**
  - Refuses to proceed unless the requested version is newer than the currently running kernel.
  - Installs only the requested kernel (no full system update on RHEL).
  - Sets it as the default boot entry so the VM boots it instead of the newest installed kernel — see "Boot mechanism" below.
  - Reboots if the running kernel differs from the target.
  - Fails the run if the VM does not come back on the requested kernel.
- After a reboot, Ansible waits for SSH to return before running attestation.
- On Ubuntu, `unattended-upgrades` is paused during the run, and `needrestart` is forced non-interactive to avoid hangs.
- The first task prints which mode was selected (`Updating to latest kernel` or `Pinning kernel to ...`). Check this line if the result is not what you expected.


## Finding available kernel versions

Run on the VM, or through `az vm run-command invoke` / SSH:

```bash
# Ubuntu
sudo apt update
apt-cache search --names-only '^linux-image-[0-9].*-azure'
apt-cache madison linux-image-azure

# RHEL
dnf list --showduplicates kernel

# SUSE
zypper search -s kernel-default
```

