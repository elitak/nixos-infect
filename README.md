# NixOS-Infect

## What is this?
A script to install NixOS on non-NixOS hosts.

NixOS-Infect is so named because of the high likelihood of rendering a system inoperable.
Use with extreme caution and preferably only on newly provisioned systems.

This script has successfully been tested on at least the follow hosting providers and plans:

* [DigitalOcean](https://www.digitalocean.com/products/droplets/)
* [Hetzner Cloud](https://www.hetzner.com/cloud)
* [Vultr](https://www.vultr.com/)
* [Interserver VPS](https://www.interserver.net/vps/)
* [Tencent Cloud Lighthouse](https://cloud.tencent.com/product/lighthouse)
* [OVHcloud](https://www.ovh.com/)
* [Oracle Cloud Infrastructure](https://www.oracle.com/cloud/)
* [GalaxyGate](https://galaxygate.net)
* [Cockbox](https://cockbox.org)
* [Google Cloud Platform](https://cloud.google.com/)
* [Contabo](https://contabo.com)
* [Liga Hosting](https://ligahosting.ro)
* [AWS Lightsail](https://aws.amazon.com/lightsail/)
* [Windcloud](https://windcloud.de/)
* [Clouding.io](https://clouding.io)

Should you find that it works on your hoster,
feel free to update this README and issue a pull request.

## Motivation

Motivation for this script: nixos-assimilate should supplant this script entirely,
if it's ever completed.
nixos-in-place was quite broken when I tried it,
and also took a pretty janky approach that was substantially more complex than this
(although it supported more platforms):
it didn't install to root (/nixos instead),
left dregs of the old filesystem
(almost always unnecessary since starting from a fresh deployment),
and most importantly, simply didn't work for me!
(old system was being because grub wasnt properly reinstalled)

## How do I use it?

0) **Read and understand the [the script](./nixos-infect)**
1) Deploy any custom configuration you want on your host
2) Deploy your host as non-Nix Operating System.
3) Deploy an SSH key for the root user.

> *NB:* This step is important.
> The root user will not have a password when nixos-infect runs to completion.
> To enable root login, you *must* have an SSH key configured.

4) run the script with:
```
  curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-22.05 bash -x
```

*NB*: This script wipes out the targeted host's root filesystem when it runs to completion.
Any errors halt execution.
A failure will leave the system in an inconsistent state,
and so it is advised to run with `bash -x`.

## Hoster notes:
### Digital Ocean
You may utilize Digital Ocean's "user data" mechanism (found in the Web UI or HTTP API),
and supply to it the following example yaml stanzas:

```yaml
#cloud-config

runcmd:
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIX_CHANNEL=nixos-22.05 bash 2>&1 | tee /tmp/infect.log
```

#### Potential tweaks:
- `/etc/nixos/{,hardware-}configuration.nix`: rudimentary mostly static config
- `/etc/nixos/networking.nix`: networking settings determined at runtime tweak if no ipv6, different number of adapters, etc.

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
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIXOS_IMPORT=./host.nix NIX_CHANNEL=nixos-22.05 bash 2>&1 | tee /tmp/infect.log
```


#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|CentOS      |6.9 x32          | _failure_ |2020-03-30|
|CentOS      |6.9 x64          | _failure_ |2020-03-30|
|CentOS      |7.6 x64          | _failure_ |2020-03-30|
|CentOS      |8.1 x64          |**success**|2020-03-30|
|CoreOS      |2345.3.0 (stable)| _unable_  |2020-03-30|
|CoreOS      |2411.1.0 (beta)  | _unable_  |2020-03-30|
|CoreOS      |2430.0.0 (alpha) | _unable_  |2020-03-30|
|Debian      |10.3 x64         |**success**|2020-03-30|
|Debian      |9.12 x64         |**success**|2020-03-30|
|Fedora      |30 x64           |**success**|2020-03-30|
|Fedora      |31 x64           |**success**|2020-03-30|
|FreeBSD     |11.3 x64 ufs     | _failure_ |2020-03-30|
|FreeBSD     |11.3 x64 zfs     | _failure_ |2020-03-30|
|FreeBSD     |12.1 x64 ufs     | _failure_ |2020-03-30|
|FreeBSD     |12.1 x64 zfs     | _failure_ |2020-03-30|
|RancherOS   |v1.5.5           | _unable_  |2020-03-30|
|Ubuntu      |16.04.6 (LTS) x32|**success**|2020-03-30|
|Ubuntu      |16.04.6 (LTS) x64|**success**|2020-03-30|
|Ubuntu      |18.04.3 (LTS) x64|**success**|2020-03-30|
|Ubuntu      |19.10 x64        |**success**|2020-03-30|
|Ubuntu      |20.04 x64        |**success**|2022-03-23|
|Ubuntu      |22.04 x64        |**success**|2022-10-14|

### Vultr

To set up a NixOS Vultr server,
instantiate an Ubuntu box with the following "Cloud-Init User-Data":

```bash
#!/bin/sh

curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-22.05 bash
```

Allow for a few minutes over the usual Ubuntu deployment time for NixOS to download & install itself.

#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
| Ubuntu     | 18.10 x64       |**success**|(Unknown) |
| Ubuntu     | 22.04 x64       |**success**|2022-07-04|


### Hetzner cloud

Hetzner cloud works out of the box.
When creating a server provide the following script as "User data":

```
#!/bin/sh

curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=hetznercloud NIX_CHANNEL=nixos-22.05 bash 2>&1 | tee /tmp/infect.log
```

#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
| Debian     | 11              |**success**|2021-11-26|
| Ubuntu     | 20.04 x64       |**success**|(Unknown) |
| Ubuntu     | 22.04 x64       |**success**|2022-06-29|

### InterServer VPS
#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Debian      | 9               |**success**|2021-01-29|
|Debian      | 10              |**success**|2021-01-29|
|Ubuntu      | 20.04           |**success**|2021-01-29|
|Ubuntu      | 18.04           |**success**|2021-01-29|
|Ubuntu      | 14.04           |**success**|2021-01-29|


### Tencent Cloud Lighthouse

Tencent Cloud Lighthouse **Hong Kong** Region Works out of the box.

Other Regions in China may not work because of the unreliable connection between China and global Internet or [GFW](https://en.wikipedia.org/wiki/Great_Firewall).

#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Debian      | 10              |**success**|2021-03-11|


### OVHcloud

Before executing the install script, you may need to check your mounts with `df -h`. By default, OVH adds a relatively short in memory `tmpfs` mount on the `/tmp` folder, so the install script runs short in memory and fails. Just execute `umount /tmp` before launching the install script. Full install process described [here](https://lyderic.origenial.fr/install-nixos-on-ovh)

|Distribution|       Name        | Status    | test date|
|------------|-------------------|-----------|----------|
|Arch Linux  | Arch Linux x86-64 |**success**|2021-03-25|
|Debian      | 10                |**success**|2021-04-29|
|Debian      | 11                |**success**|2021-11-17|
|Ubuntu      | 22.04             |**success**|2022-06-19|

### Oracle Cloud Infrastructure
Tested for both VM.Standard.E2.1.Micro (x86) and VM.Standard.A1.Flex (AArch64) instances.
#### Tested on
|Distribution|       Name      | Status    | test date|   Shape  |
|------------|-----------------|-----------|----------|----------|
|Oracle Linux| 7.9             |**success**|2021-05-31|          |
|Ubuntu      | 20.04           |**success**|2022-03-23|          |
|Ubuntu      | 20.04           |**success**|2022-04-19| free arm |
|Oracle Linux| 8.0             | -failure- |2022-04-19| free amd |
|CentOS      | 8.0             | -failure- |2022-04-19| free amd |
|Oracle Linux| 7.9[1]          |**success**|2022-04-19| free amd |
|Ubuntu      | 22.04           |**success**|2022-11-13| free arm |

    [1] The Oracle 7.9 layout has 200Mb for /boot 8G for swap
    PR#100 Adopted 8G Swap device
    
### Aliyun ECS

Aliyun ECS tested on ecs.s6-c1m2.large, region **cn-shanghai**, needs a little bit tweaks:

- replace nix binary cache with [tuna mirror](https://mirrors.tuna.tsinghua.edu.cn/help/nix/) (with instructions in the page)

#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Ubuntu      | 20.04           |**success**|2021-12-28|


### GalaxyGate
#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Ubuntu      | 20.04           |**success**|2022-04-02|


### Cockbox
Requred some Xen modules to work out, after that NixOS erected itself without a hinch.
#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Ubuntu      | 20.04           |**success**|2022-06-12|

### Google Cloud Platform

#### Tested on
|Distribution.                        |       Name      | Status    | test date|
|-------------------------------------|-----------------|-----------|----------|
| Ubuntu on Ampere Altra (Arm64)      | 20.04           |**success**|2022-09-07|

### Contabo
Tested on Cloud VPS. Contabo sets the hostname to something like `vmi######.contaboserver.net`, Nixos only allows RFC 1035 compliant hostnames ([see here](https://search.nixos.org/options?show=networking.hostName&query=hostname)). Run `hostname something_without_dots` before running the script. If you run the script before changing the hostname - remove the `/etc/nixos/configuration.nix` so it's regenerated with the new hostname.
#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Ubuntu      | 22.04           |**success**|2022-09-26|

### Liga Hosting

Liga Hosting works without any issue.  You'll need to add your ssh key to the host either during
build time or using `ssh-copy-id` before running nixos-infect

```
#!/bin/sh

curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-22.11 bash 2>&1 | tee /tmp/infect.log
```

#### Tested on
|Distribution|       Name      | Status    | test date| 
|------------|-----------------|-----------|----------| 
|Debian      | 11              |**success**|2022-12-01|  
|Ubuntu      | 20.04           |**success**|2022-12-01| 
|Ubuntu      | 22.04           |**success**|2022-12-01| 

### AWS Lightsail
Make sure to set `PROVIDER="lightsail"`. 

Setting a root ssh key manually is not necessary, the key provided as part of the instance launch process will be used.

If you run into issues, debug using the most similar ec2 instance that is on the Nitro platform. Nitro platform instances have a serial console that allow you to troubleshoot boot issues, and Lightsail instances are just EC2 with a different pricing model and UI.

### Windcloud
Tested on vServer. The network configuration seems to be important so the same tweaks as for DigitalOcean are necessary (see above).
#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Ubuntu      | 20.04           |**success**|2022-12-09|

### ServArica
Requires the same static network settings that Digital Ocean does.

    curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | PROVIDER=servarica NIX_CHANNEL=nixos-22.05 bash

#### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Debian      | 11.4            |**success**|2022-12-12|
|Ubuntu      | 20.04           | success   |2022-11-26|

### Clouding.io
I could not get it to run via UserData scripts, but downloading and executing the script worked flawlessly.
### Tested on
|Distribution|       Name      | Status    | test date|
|------------|-----------------|-----------|----------|
|Debian      | 11              |**success**|2022-12-20|

