resource "null_resource" "update_kernel" {
  count = var.kernel_update_enabled ? 1 : 0

  depends_on = [azurerm_linux_virtual_machine.cvm]

  triggers = {
    instance_id = azurerm_linux_virtual_machine.cvm.id
  }

  connection {
    type        = "ssh"
    user        = var.cvm_username
    private_key = file(trimsuffix(var.cvm_ssh_pubkey, ".pub"))
    host        = azurerm_linux_virtual_machine.cvm.public_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      <<-EOT
        set -eu
        . /etc/os-release
        KERNEL_VERSION="${var.kernel_version == null ? "" : var.kernel_version}"
        case "$ID" in
          ubuntu)
            sudo env DEBIAN_FRONTEND=noninteractive apt-get update
            if [ -n "$KERNEL_VERSION" ]; then
              sudo env DEBIAN_FRONTEND=noninteractive apt-get install --yes --install-recommends "linux-generic=$KERNEL_VERSION"
            else
              sudo env DEBIAN_FRONTEND=noninteractive apt-get install --yes --install-recommends linux-generic
            fi
            ;;
          rhel|centos|fedora|rocky|almalinux|amzn)
            dnf_retry() {
              attempts=0
              until sudo dnf "$@"; do
                attempts=$((attempts + 1))
                if [ "$attempts" -ge 5 ]; then
                  echo "dnf command failed after $attempts attempts: $*" >&2
                  return 1
                fi
                sudo dnf clean all || true
                sleep 10
              done
            }
            sudo dnf clean all
            if command -v dnf >/dev/null 2>&1; then
              dnf_retry makecache --refresh
              if [ -n "$KERNEL_VERSION" ]; then dnf_retry install --assumeyes "kernel-$KERNEL_VERSION"; else dnf_retry upgrade --assumeyes 'kernel*'; fi
            else
              if [ -n "$KERNEL_VERSION" ]; then sudo yum install --assumeyes "kernel-$KERNEL_VERSION"; else sudo yum update --assumeyes 'kernel*'; fi
            fi
            ;;
          opensuse*|sles)
            sudo zypper --non-interactive refresh
            if [ -n "$KERNEL_VERSION" ]; then sudo zypper --non-interactive install "kernel-default=$KERNEL_VERSION"; else sudo zypper --non-interactive update --type package kernel-default; fi
            ;;
          *)
            echo "Unsupported Linux distribution: $ID" >&2
            exit 1
            ;;
        esac

        if [ -f /var/run/reboot-required ] || { command -v needs-restarting >/dev/null 2>&1 && sudo needs-restarting --reboothint; }; then
          sudo shutdown -r +1 'Kernel update completed'
        fi
      EOT
    ]
  }
}
