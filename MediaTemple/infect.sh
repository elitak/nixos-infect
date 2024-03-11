#!/usr/bin/env bash
set -e -o pipefail

# Add build group and user
groupadd nixbld -g 30000 || true
for i in {1..10}; do
  useradd -c "Nix build user $i" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" "nixbld$i" || true
done

# Install NixOS
curl -L https://nixos.org/nix/install | sh
. /root/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://nixos.org/channels/nixos-21.05 nixpkgs
nix-channel --update

# Install NixOS installation tools, TODO: Make nicer
nix-env -iE "_: with import <nixpkgs/nixos> { configuration = {}; }; with config.system.build; [ nixos-generate-config ]"

# Set up configurations and install it in a profile
nixos-generate-config
echo "---"
echo "Remove the lxcfs (on Ubuntu 16.04) or squashfs (on Ubuntu 20.04 and 21.04) entry with nano"
sleep 5
nano /etc/nixos/hardware-configuration.nix
cp configuration.nix /etc/nixos
nix-env -p /nix/var/nix/profiles/system -f '<nixpkgs/nixos>' -I nixos-config=/etc/nixos/configuration.nix -iA system

# Set NixOS to boot and replace the original distro
touch /etc/NIXOS
cat > /etc/NIXOS_LUSTRATE <<EOF
etc/nixos
root/.nix-defexpr/channels
EOF

# Switch to NixOS OS
/nix/var/nix/profiles/system/bin/switch-to-configuration boot

echo "---"
echo "Verify all the settings and check if there were any problematic errors."
echo "If everything is OK, reboot"
echo ""
echo "Keep in mind that you have to deal with /old-root after reboot"
