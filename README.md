This script aims to install NixOS on Digital Ocean droplets
(starting from one of the distros that Digital Ocean supports out of the box)

These are the only supported Digital Ocean images:

- Fedora 24 x64
- Ubuntu 16.04 x64

It has also been successfully tested on OVH Virtual Private Servers (with debian)

YMMV with any other hoster + image combination.

nixos-infect is so named because of the high likelihood of rendering a system
inoperable. Use with caution and preferably only on newly-provisioned
systems.

*WARNING NB*: This script wipes out the targeted host's root filesystem when it
runs to completion. Any errors halt execution. It's advised to run with
`bash -x` to help debug, as often a failed run leaves the system in an
inconsistent state, requiring a rebuild (in DigitalOcean panel: Droplet
Settings -> "Destroy" -> "Rebuild from original").

*TO USE:*
- Add any custom config you want (see notes below)
- Deploy the droplet indicated at the top of the file, enable ipv6, add your ssh key
- cat customConfig.optional nixos-infect | ssh root@targethost

Alternatively, use the user data mechamism by supplying the lines between the following
cat and EOF in the Digital Ocean Web UI (or HTTP API):

```yaml
#cloud-config

runcmd:
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-18.09 bash 2>&1 | tee /tmp/infect.log
```
Potential tweaks:
- `/etc/nixos/{,hardware-}configuration.nix`: rudimentary mostly static config
- `/etc/nixos/networking.nix`, networking settings determined at runtime tweak
  if no ipv6, different number of adapters, etc.

```yaml
#cloud-config
write_files:
- path: /etc/nixos/host.nix
  permissions: '0644'
  content: |
    {pkgs, ...}:
    {
      environment.systemPackages = with pkgs; [ vim ];
    }
runcmd:
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIXOS_IMPORT=./host.nix NIX_CHANNEL=nixos-18.09 bash 2>&1 | tee /tmp/infect.log

```

Motivation for this script: nixos-assimilate should supplant this script
entirely, if it's ever completed. nixos-in-place was quite broken when I
tried it, and also took a pretty janky approach that was substantially more
complex than this (although it supported more platforms): it didn't install
to root (/nixos instead), left dregs of the old filesystem (almost always
unnecessary since starting from a fresh deployment), and most importantly,
simply didn't work for me! (old system was being because grub wasnt properly
reinstalled)
