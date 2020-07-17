This set of scripts aims to create fresh instance of [holo-nixpkgs](https://github.com/Holo-Host/holo-nixpkgs) based Hydra on a Digital Ocean droplet. The process consists of two stages - creating server and restoring configuration from keystore file and backup.

## Creating server
First create new droplet on Digital Ocean with minimum 16GB of RAM and `Ubuntu 16.04 x64` operating system. Use your ssh key for authentication. Also enable ipv6.

Ssh into your new droplet. Exec in shell:
```bash
curl https://raw.githubusercontent.com/Holo-Host/holo-hydra-create/master/holo-hydra-create | bash 2>&1 | tee /tmp/hydra_config.log
```
After successful run system will reboot into newly created empty Hydra.

## Restoring configuration

First import a file `hydra-keystore.enc` to server's `~/` dir. The file is encrypted and password protected as it contains all the security credentials required to configure Hydra. It will be securely erased after successful creation of Hydra. The file itself and encryption password can be obtained from Service Ops, or created from `hydra-keystore-template` and encrypted using command:
```
openssl enc -aes-256-cbc -salt -in hydra-keystore-template -out hydra-keystore.enc
```

Once `hydra-keystore.enc` is in place run 
```bash
holo-hydra-restore
```
and watch terminal output for prompts.

## Switching DNS
Once you see the line `Hydra restored from backup successfully` you can wait ~1h for hydra to finish evaluations (or watch logs with `journalctl -f -u hydra-evaluator` until evaluations are done) and the switch `hydra.holo.host` in Cloudflare's DNS to the new Hydra's IP.

## Acknowledgements

Based on [nixos-infect](https://github.com/elitak/nixos-infect/blob/master/nixos-infect).
