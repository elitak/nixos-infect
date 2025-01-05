
# NixOS-Infect

This repository has been updated by [@jr551](https://github.com/jr551), who merged contributions from several pull requests that had been pending approval. These contributions include important fixes, documentation updates, and support for additional hosting providers. A big thanks to all the contributors who made these improvements possible!

If you find that it works on your hoster, feel free to update this README and issue a pull request.

## What is this?

A script to install NixOS on non-NixOS hosts.

**NixOS-Infect** is so named because of the high likelihood of rendering a system inoperable. Use with extreme caution and preferably only on newly provisioned systems.

This script has successfully been tested on the following hosting providers and plans:

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
* [Scaleway](https://scaleway.com)
* [RackNerd](https://my.racknerd.com/index.php?rp=/store/black-friday-2022)

If you find that it works on your hoster, feel free to update this README and issue a pull request.

## Motivation

The motivation for this script is to provide a simpler and more reliable method for installing NixOS on existing systems compared to alternatives like `nixos-assimilate` and `nixos-in-place`. The latter were either incomplete, overly complex, or failed to work reliably in various scenarios.

## How do I use it?

1. **Read and understand the [script](./nixos-infect).**
2. **Deploy any custom configuration you want on your host.**
3. **Deploy your host as a non-Nix Operating System.**
4. **Deploy an SSH key for the root user.**

   > **NB:** This step is crucial. The root user will not have a password when `nixos-infect` completes. To enable root login, you *must* have an SSH key configured. If a custom SSH port is used, it will be reverted back to 22.

5. **Run the script with:**

   ```bash
   curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-25.05 bash -x
   ```

   > **NB:** This script wipes out the targeted host's root filesystem upon completion. Any errors will halt execution, potentially leaving the system in an inconsistent state. It is advised to run with `bash -x` for debugging purposes.

## Hoster Notes

### DigitalOcean

You can utilize DigitalOcean's "user data" mechanism (available in the Web UI or via the HTTP API) by supplying the following example YAML stanzas:

```yaml
#cloud-config

runcmd:
  - curl https://raw.githubusercontent.com/jr551/nixos-infect/master/nixos-infect | PROVIDER=digitalocean NIX_CHANNEL=nixos-25.05 bash 2>&1 | tee /tmp/infect.log
```

#### Potential Tweaks:

- **Configuration Files:**
  - `/etc/nixos/{,hardware-}configuration.nix`: Rudimentary mostly static config.
  - `/etc/nixos/networking.nix`: Networking settings determined at runtime. Tweak if no IPv6, different number of adapters, etc.

```yaml
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
```

#### Tested On

| Distribution | Name                | Status      | Test Date  |
|--------------|---------------------|-------------|------------|
| CentOS       | 6.9 x32             | _failure_   | 2020-03-30 |
| CentOS       | 6.9 x64             | _failure_   | 2020-03-30 |
| CentOS       | 7.6 x64             | _failure_   | 2020-03-30 |
| CentOS       | 8.1 x64             | **success** | 2020-03-30 |



## Contributing

Contributions are welcome! If you find that the script works on your hosting provider, please update this README and submit a pull request. Ensure to include relevant details and test results to help others benefit from your improvements.

## Disclaimer

**Use NixOS-Infect at your own risk.** This script can render your system inoperable. It is recommended to use it only on newly provisioned systems or environments where data loss is acceptable.

## License

This project is licensed under the [MIT License](./LICENSE).

## Acknowledgements

Special thanks to all contributors and the NixOS community for their continuous support and enhancements.
