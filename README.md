This script aims to create fresh instance of [holo-nixpkgs](https://github.com/Holo-Host/holo-nixpkgs) based Hydra on a Digital Ocean droplet.

## Base droplet
Create new droplet on Digital Ocean with minimum 16GB of RAM and `Ubuntu 16.04 x64` operating system. Use your ssh key for authentication. Also enable ipv6.

## Executing script
Ssh into your new droplet. First create a file `keystore` in current dir based on `keystore-template`, which will contain all the security credentials required to configure Hydra. It will be securely erased after successful creation of Hydra.

Then exec in shell:
```bash
curl https://raw.githubusercontent.com/Holo-Host/holo-hydra-create/master/holo-hydra-create | bash -x 2>&1 | tee /tmp/hydra_config.log
```
After successful run droplet will reboot into newly created Hydra.

## Acknowledgements

Based on [nixos-infect](https://github.com/elitak/nixos-infect/blob/master/nixos-infect).
