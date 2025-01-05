NixOS-Infect
This repository has been updated by @jr551, who merged contributions from several pull requests that had been pending approval. These contributions include important fixes, documentation updates, and support for additional hosting providers. A big thanks to all the contributors who made these improvements possible!

If you find that it works on your hoster, feel free to update this README and issue a pull request.

What is this?
A script to install NixOS on non-NixOS hosts.

NixOS-Infect is so named because of the high likelihood of rendering a system inoperable. Use with extreme caution and preferably only on newly provisioned systems.

This script has successfully been tested on the following hosting providers and plans:

DigitalOcean
Hetzner Cloud
Vultr
Interserver VPS
Tencent Cloud Lighthouse
OVHcloud
Oracle Cloud Infrastructure
GalaxyGate
Cockbox
Google Cloud Platform
Contabo
Liga Hosting
AWS Lightsail
Windcloud
Clouding.io
Scaleway
RackNerd
If you find that it works on your hoster, feel free to update this README and issue a pull request.

Motivation
The motivation for this script is to provide a simpler and more reliable method for installing NixOS on existing systems compared to alternatives like nixos-assimilate and nixos-in-place. The latter were either incomplete, overly complex, or failed to work reliably in various scenarios.

How do I use it?
Read and understand the script.

Deploy any custom configuration you want on your host.

Deploy your host as a non-Nix Operating System.

Deploy an SSH key for the root user.

NB: This step is crucial. The root user will not have a password when nixos-infect completes. To enable root login, you must have an SSH key configured. If a custom SSH port is used, it will be reverted back to 22.

Run the script with:

bash
Copy code
curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-25.05 bash -x
NB: This script wipes out the targeted host's root filesystem upon completion. Any errors will halt execution, potentially leaving the system in an inconsistent state. It is advised to run with bash -x for debugging purposes.

Hoster Notes
DigitalOcean
You can utilize DigitalOcean's "user data" mechanism (available in the Web UI or via the HTTP API) by supplying the following example YAML stanzas:

yaml
Copy code
#cloud-config

runcmd:
  - curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIX_CHANNEL=nixos-25.05 bash 2>&1 | tee /tmp/infect.log
Potential Tweaks:
Configuration Files:
/etc/nixos/{,hardware-}configuration.nix: Rudimentary mostly static config.
/etc/nixos/networking.nix: Networking settings determined at runtime. Tweak if no IPv6, different number of adapters, etc.
yaml
Copy code
#cloud-config
write_files:
- path: /etc/nixos/host.nix
  permissions: '0644'
  content: |
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ vim ];
    }
runcmd:
  - curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIXOS_IMPORT=./host.nix NIX_CHANNEL=nixos-25.05 bash 2>&1 | tee /tmp/infect.log
Tested On
Distribution	Name	Status	Test Date
CentOS	6.9 x32	failure	2020-03-30
CentOS	6.9 x64	failure	2020-03-30
CentOS	7.6 x64	failure	2020-03-30
CentOS	8.1 x64	success	2020-03-30
CoreOS	2345.3.0 (stable)	unable	2020-03-30
CoreOS	2411.1.0 (beta)	unable	2020-03-30
CoreOS	2430.0.0 (alpha)	unable	2020-03-30
Debian	10.3 x64	success	2020-03-30
Debian	9.12 x64	success	2020-03-30
Debian	11 x64	success	2023-11-12
Fedora	30 x64	success	2020-03-30
Fedora	31 x64	success	2020-03-30
FreeBSD	11.3 x64 ufs	failure	2020-03-30
FreeBSD	11.3 x64 zfs	failure	2020-03-30
FreeBSD	12.1 x64 ufs	failure	2020-03-30
FreeBSD	12.1 x64 zfs	failure	2020-03-30
RancherOS	v1.5.5	unable	2020-03-30
Ubuntu	16.04.6 (LTS) x32	success	2020-03-30
Ubuntu	16.04.6 (LTS) x64	success	2020-03-30
Ubuntu	18.04.3 (LTS) x64	success	2020-03-30
Ubuntu	19.10 x64	success	2020-03-30
Ubuntu	20.04 x64	success	2022-03-23
Ubuntu	22.04 x64	success	2023-06-05
Ubuntu	22.10 x64	failure	2023-06-05
Ubuntu	23.10 x64	failure	2023-11-16
Vultr
To set up a NixOS Vultr server, instantiate an Ubuntu box with the following "Cloud-Init User-Data":

bash
Copy code
#!/bin/sh

curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-25.05 bash
Allow a few extra minutes beyond the usual Ubuntu deployment time for NixOS to download and install itself.

Tested On
Distribution	Name	Status	Test Date
Ubuntu	18.10 x64	success	(Unknown)
Ubuntu	22.04 x64	success	2022-07-04
Hetzner Cloud
Hetzner Cloud works out of the box. When creating a server, provide the following YAML as "Cloud config":

yaml
Copy code
#cloud-config

runcmd:
  - curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | PROVIDER=hetznercloud NIX_CHANNEL=nixos-25.05 bash 2>&1 | tee /tmp/infect.log
Tested On
Distribution	Name	Status	Test Date
Debian	11	success	2023-04-29
Debian	12 aarch64	success	2023-09-02
Ubuntu	20.04 x64	success	(Unknown)
Ubuntu	22.04 x64	success	2023-04-29
Ubuntu	22.04 aarch64	success	2023-04-16
InterServer VPS
Tested On
Distribution	Name	Status	Test Date
Debian	9	success	2021-01-29
Debian	10	success	2021-01-29
Ubuntu	20.04	success	2021-01-29
Ubuntu	18.04	success	2021-01-29
Ubuntu	14.04	success	2021-01-29
Tencent Cloud Lighthouse
Tencent Cloud Lighthouse Hong Kong Region works out of the box.

Other regions in China may not work due to unreliable connections between China and the global Internet or the Great Firewall of China.

Tested On
Distribution	Name	Status	Test Date
Debian	10	success	2021-03-11
OVHcloud
Before executing the install script, you may need to check your mounts with df -h. By default, OVH adds a relatively short in-memory tmpfs mount on the /tmp folder, causing the install script to run short on memory and fail. Execute umount /tmp before launching the install script. The full install process is described here.

Tested On
Distribution	Name	Status	Test Date
Arch Linux	Arch Linux x86-64	success	2021-03-25
Debian	10	success	2021-04-29
Debian	11	success	2021-11-17
Ubuntu	22.04	success	2022-06-19
Ubuntu	23.04	failure due to e2fsck error	2023-06-01
Note: The Ubuntu 23.04 distribution fails to boot due to the following error:

scss
Copy code
/dev/sda1 has unsupported feature(s): FEATURE_C12

e2fsck: Get a newer version of e2fsck
Using an older Ubuntu version fixes this issue.

Oracle Cloud Infrastructure
Tested for both VM.Standard.E2.1.Micro (x86) and VM.Standard.A1.Flex (AArch64) instances.

Tested On
Distribution	Name	Status	Test Date	Shape
Oracle Linux	7.9	success	2021-05-31	
Ubuntu	20.04	success	2022-03-23	
Ubuntu	20.04	success	2022-04-19	free arm
Oracle Linux	8.0	failure	2022-04-19	free amd
CentOS	8.0	failure	2022-04-19	free amd
Oracle Linux	7.9[1]	success	2022-04-19	free amd
Ubuntu	22.04	success	2022-11-13	free arm
Oracle Linux	9.1[2]	success	2023-03-29	free arm
Oracle Linux	8.7[3]	success	2023-06-06	free amd
AlmaLinux OS	9.2.20230516	success	2023-07-05	free arm
[1] The Oracle 7.9 layout has 200MB for /boot and 8G for swap. PR#100 Adopted 8G Swap device.

[2] OL9.1 had 2GB /boot, 100MB /boot/efi (NixOS used as /boot), and a swapfile.

[3] Both 22.11 and 23.05 failed to boot, but installing 22.05 and then upgrading worked as intended.

Aliyun ECS
Aliyun ECS tested on ecs.s6-c1m2.large, region cn-shanghai. Requires a few tweaks:

Replace Nix binary cache with the TUNA mirror (instructions provided on the page).
Tested On
Distribution	Name	Status	Test Date
Ubuntu	20.04	success	2021-12-28
Ubuntu	22.04	success	2023-04-05
Debian	12.4	success	2024-12-24
GalaxyGate
Tested On
Distribution	Name	Status	Test Date
Ubuntu	20.04	success	2022-04-02
Cockbox
Required some Xen modules to be enabled. After that, NixOS installed without issues.

Tested On
Distribution	Name	Status	Test Date
Ubuntu	20.04	success	2022-06-12
Google Cloud Platform
Tested On
Distribution	Name	Status	Test Date	Machine Type
Debian	11	success	2023-11-12	ec2-micro
Debian (Amd64)	11	success	2023-11-12	
Ubuntu on Ampere Altra (Arm64)	20.04	success	2022-09-07	
Ubuntu	20.04	success	2022-09-07	Ampere Ultra
Ubuntu	20.04	failure	2023-11-12	ec2-micro
Contabo
Tested on Cloud VPS. Contabo sets the hostname to something like vmi######.contaboserver.net. NixOS only allows RFC 1035 compliant hostnames (see here). Run hostname something_without_dots before running the script. If you run the script before changing the hostname, remove the /etc/nixos/configuration.nix so it's regenerated with the new hostname.

Tested On
Distribution	Name	Status	Test Date
Ubuntu	22.04	success	2022-09-26
Liga Hosting
Liga Hosting works without any issues. You'll need to add your SSH key to the host either during build time or using ssh-copy-id before running nixos-infect.

bash
Copy code
#!/bin/sh

curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-25.05 bash 2>&1 | tee /tmp/infect.log
Tested On
Distribution	Name	Status	Test Date
Debian	11	success	2022-12-01
Ubuntu	20.04	success	2022-12-01
Ubuntu	22.04	success	2022-12-01
AWS Lightsail
Ensure to set PROVIDER="lightsail".

Setting a root SSH key manually is not necessary; the key provided as part of the instance launch process will be used.

If you encounter issues, debug using the most similar EC2 instance that is on the Nitro platform. Nitro platform instances have a serial console that allows you to troubleshoot boot issues, and Lightsail instances are essentially EC2 with a different pricing model and UI.

Windcloud
Tested on vServer. Network configuration is crucial, so the same tweaks as for DigitalOcean are necessary (see above).

Tested On
Distribution	Name	Status	Test Date
Ubuntu	20.04	success	2022-12-09
ServArica
Requires the same static network settings as DigitalOcean.

bash
Copy code
curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | PROVIDER=servarica NIX_CHANNEL=nixos-25.05 bash
Tested On
Distribution	Name	Status	Test Date
Debian	11.4	success	2022-12-12
Ubuntu	20.04	success	2022-11-26
Clouding.io
I could not get it to run via UserData scripts, but downloading and executing the script worked flawlessly.

Tested On
Distribution	Name	Status	Test Date
Debian	11	success	2022-12-20
Scaleway
As of November 2020, it is easy to get a NixOS VM running on Scaleway by using nixos-infect and Scaleway's support for cloud-init. Follow the nixos-infect recipe for DigitalOcean, removing DigitalOcean-specific configurations.

Start an Ubuntu or Fedora VM and use the following as your cloud-init startup script:

cloud
Copy code
#cloud-config
write_files:
- path: /etc/nixos/host.nix
  permissions: '0644'
  content: |
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ tmux ];
    }
runcmd:
  - curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | NIXOS_IMPORT=./host.nix NIX_CHANNEL=nixos-25.05 bash 2>&1 | tee /tmp/infect.log
Tested On
Distribution	Name	Status	Test Date
Ubuntu	20.04	success	2020-11-??
vbnet
Copy code

### RackNerd

Ensure that SSH keys are manually added, as they are not automatically generated/uploaded. Create them using `ssh-keygen` or another method, add the public key to the `.ssh/authorized_keys` file on the remote host, and retain a copy of the private key on your local machine.

On RackNerd's Ubuntu 20.04, `curl` is not installed by default. Use `wget` instead:

```bash
wget -O- https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-25.05 bash -x
Tested On
Distribution	Name	Status	Test Date
AlmaLinux	8	failure (tar missing)	2023-08-29
Ubuntu	20.04	success	2023-08-29
IBM Cloud VPC
Ensure that SSH keys are manually added, as they are not automatically generated/uploaded. Create them using ssh-keygen or another method, add the public key to the .ssh/authorized_keys file on the remote host, and retain a copy of the private key on your local machine.

The SSH key can be added as part of the instance creation process.

On IBM's Debian 20.04, curl is not installed by default. Install it first:

bash
Copy code
apt update
apt install curl
Tested On
Distribution	Name	Status	Test Date
Debian	12.6	success	2024-11-12
Webdock
You cannot add SSH keys to the root user through the web interface. Manually add a public key to /root/.ssh/authorized_keys.

Ensure to set PROVIDER=webdock.

Tested On
Distribution	Name	Status	Test Date
Ubuntu	20.04	success	2024-10-26
Ubuntu	22.04	success	2024-10-26
Contributing
Contributions are welcome! If you find that the script works on your hosting provider, please update this README and submit a pull request. Ensure to include relevant details and test results to help others benefit from your improvements.

Disclaimer
Use NixOS-Infect at your own risk. This script can render your system inoperable. It is recommended to use it only on newly provisioned systems or environments where data loss is acceptable.

License
This project is licensed under the MIT License.

Acknowledgements
Special thanks to all contributors and the NixOS community for their continuous support and enhancements.

Feel free to further customize this README based on specific updates, additional testing results, or other relevant information pertinent to your repository.