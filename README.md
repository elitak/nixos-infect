# NIXOS-INFECT

This script aims to install NixOS on Digital Ocean droplets, Vultr servers, or
OVH Virtual Private Servers (starting from distros that these services support
out of the box).

## Source Distributions

Nixos-infect can install NixOS over multiple distributions. The known working
(and some non-working) distributions on different service providers are as follows:

### On Digital Ocean

(information from doctl as of 2020-03-30)

|Distribution|       Name      | Status | test date|   Slug           |   ID   |
|------------|-----------------|--------|----------|------------------|--------|
|CentOS      |6.9 x32          | _failure_ |2020-03-30|centos-6-x32      |31354013|
|CentOS      |6.9 x64          | _failure_ |2020-03-30|centos-6-x64      |34902021|
|CentOS      |7.6 x64          | _failure_ |2020-03-30|centos-7-x64      |50903182|
|CentOS      |8.1 x64          |**success**|2020-03-30|centos-8-x64      |58134745|
|CoreOS      |2345.3.0 (stable)| _unable_  |2020-03-30|coreos-stable     |60030597|
|CoreOS      |2411.1.0 (beta)  | _unable_  |2020-03-30|coreos-beta       |59918930|
|CoreOS      |2430.0.0 (alpha) | _unable_  |2020-03-30|coreos-alpha      |59917914|
|Debian      |10.3 x64         |**success**|2020-03-30|debian-10-x64     |60461760|
|Debian      |9.12 x64         |**success**|2020-03-30|debian-9-x64      |60463541|
|Fedora      |30 x64           |**success**|2020-03-30|fedora-30-x64     |47384041|
|Fedora      |31 x64           |**success**|2020-03-30|fedora-31-x64     |56521921|
|FreeBSD     |11.3 x64 ufs     | _failure_ |2020-03-30|freebsd-11-x64-ufs|59418769|
|FreeBSD     |11.3 x64 zfs     | _failure_ |2020-03-30|freebsd-11-x64-zfs|59418853|
|FreeBSD     |12.1 x64 ufs     | _failure_ |2020-03-30|freebsd-12-x64    |59416024|
|FreeBSD     |12.1 x64 zfs     | _failure_ |2020-03-30|freebsd-12-x64-zfs|59417005|
|RancherOS   |v1.5.5           | _unable_  |2020-03-30|rancheros         |58230630|
|Ubuntu      |16.04.6 (LTS) x32|**success**|2020-03-30|ubuntu-16-04-x32  |54203610|
|Ubuntu      |16.04.6 (LTS) x64|**success**|2020-03-30|ubuntu-16-04-x64  |55022766|
|Ubuntu      |18.04.3 (LTS) x64|**success**|2020-03-30|ubuntu-18-04-x64  |53893572|
|Ubuntu      |19.10 x64        |**success**|2020-03-30|ubuntu-19-10-x64  |53871280|

#### CentOS

- CentOS 8.1 x64  *successful* as of 2020-03-30

CentOS tested as not working

- CentOS 6.9 x32/x64 *unsuccessful* nix fails to install as of 2020-03-30
- CentOS 7.6 x64  *unsuccessful* hangs at nix installation step as of 2020-03-30

#### Debian

- Debian 10.3 x64 *successful* as of 2020-03-30
- Debian 9.12 x64 *successful* as of 2020-03-30

#### Fedora

- Fedora 31 x64 *successful* as of 2020-03-30
- Fedora 30 x64 *successful* as of 2020-03-30
- Fedora 24 x64 *successful* as of unknown - obsolete at this time

#### Ubuntu

- Ubuntu 19.10 x64 *successful* as of 2020-03-30
- Ubuntu 18.04.3 (LTS) x64 *successful* as of 2020-03-30
- Ubuntu 16.04.6 (LTS) x64 *successful* as of 2020-03-30
- Ubuntu 16.04.6 (LTS) x32 *successful* as of 2020-03-30

#### Notes on FreeBSD, CoreOS, RancherOS
FreeBSD is not supported by the nix install script at this time. So it is not
possible for this script to succeed. When testing CoreOS and RancherOS ssh did
not work and thus attempting was not possible. Assume it would fail. No reason to use them
or expect them to work anyway with the abundance of other choices and it gets
deleted anyway.

#### Choose Your Fighter

It doesn't really matter too much which one you pick. It may make a difference
on low memory installations. There might be unknown problems with the script that only affect
certain OS. The primary difference post install is how it affects the name DO uses
for the droplet. The chosen Image will be an artifact appearing in the interface
and API at times. Keep that in mind if it's a detail you care about.

### On Vultr

- Ubuntu 18.10 x64

### On OVH Virtual Private Servers (experimental)

- Debian

### On Hetzner cloud

- Ubuntu 18.04

YMMV with any other hoster + image combination.

If you have a OpenVZ based virtualization solution then this, or any other OS takeover script will not work, this is fundamental to how OpenVZ works.

## Considerations

nixos-infect is so named because of the high likelihood of rendering a system
inoperable. Use with caution and preferably only on newly-provisioned
systems. and wash your hands frequently.

*WARNING NB*: This script wipes out the targeted host's root filesystem when it
runs to completion. Any errors halt execution. It's advised to run with
`bash -x` to help debug, as often a failed run leaves the system in an
inconsistent state, requiring a rebuild (in DigitalOcean panel: Droplet
Settings -> "Destroy" -> "Rebuild from original").

*NB*: There will be an /old-root/ directory after first boot. It is most likely not
required and you may delete it. Or don't. It might be useful someday. It's
possible that there's a reason to keep it I don't know about... yet. You
decide for yourself if you want the ~1GB of space recovered. Remember, it's at
your own risk. No warranty! :)

## Usage

### Digital Ocean

*TO USE:*

*NB*: It is important (or at least helpful) to configure all network interfaces
correctly before install. That way the script can detect and properly configure
everything correctly. It's required to enable IPv6. (It's possible to not
enable but you may have errors in the generated `networking.nix` requiring
intervention) If you plan to use Private Networking it's easiest to enable it
before nixos-infect as it adds a secondary interface. Likewise, Floating IPs
use an additional private IP on the primary interface. So if you wish to use
Floating IPs it's best to assign one prior so that nixos-infect will detect it.
It's possible Monitoring features make use of that as well. Not sure.

- Add any custom config you want (see notes below)
- Deploy a supported droplet as listed above, making sure to
  - (required) include your ssh key
  - (required) enable IPv6
  - (optional) set a Floating IP
  - (optional) enable Private Networking
- `cat customConfig.optional nixos-infect | ssh root@targethost`

Alternatively, use the user data mechamism by supplying the lines between the following
cat and EOF in the Digital Ocean Web UI (or HTTP API):

```yaml
#cloud-config

runcmd:
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIX_CHANNEL=nixos-19.09 bash 2>&1 | tee /tmp/infect.log
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
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIXOS_IMPORT=./host.nix NIX_CHANNEL=nixos-19.09 bash 2>&1 | tee /tmp/infect.log

```

## Vultr

To set up a NixOS Vultr server, instantiate an Ubuntu box with the following "Startup Script":

```bash
#!/bin/sh

curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=vultr NIX_CHANNEL=nixos-19.09 bash
```

Allow for a few minutes over the usual Ubuntu deployment time for NixOS to download & install itself.

## Hetzner cloud

We need to replace our nameserver to point to the dedicated Hetzner DNS as opposed to `127.0.0.1:53` which is specific to Ubuntu.

```
sed -i "/nameserver/d" /etc/resolv.conf
echo "nameserver 213.133.98.98" >> /etc/resolv.conf
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIXOS_IMPORT=./host.nix NIX_CHANNEL=nixos-19.09 bash 2>&1 | tee /tmp/infect.log
```

## Motivation

Motivation for this script: nixos-assimilate should supplant this script
entirely, if it's ever completed. nixos-in-place was quite broken when I
tried it, and also took a pretty janky approach that was substantially more
complex than this (although it supported more platforms): it didn't install
to root (/nixos instead), left dregs of the old filesystem (almost always
unnecessary since starting from a fresh deployment), and most importantly,
simply didn't work for me! (old system was being because grub wasnt properly
reinstalled)
