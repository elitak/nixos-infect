# NixOS-Infect

NixOS-Infect is a tool designed to automate the installation of [NixOS](https://nixos.org/) on non-NixOS Linux hosts, simplifying server transformations with no manual intervention.

## Overview

It allows DevOps to seamlessly migrate Linux systems to NixOS.

## Usage Guide

### Deploying on an existing server

To install NixOS on an already-provisioned server, execute the following command:  
```bash
curl https://raw.githubusercontent.com/lambdaclass/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-24.11 bash 2>&1 | tee /tmp/infect.log
```
> ⚠️ **Warning**
>
> Running this script will **completely wipe the target host's root filesystem**.
>
> Proceed with caution and ensure you have adequate backups.

### Deploying on a yet-to-be-created server (cloud-config)
Add the following code to the **Cloud Config** section on **Hetzner Cloud**
```yaml
runcmd:
  - curl https://raw.githubusercontent.com/lambdaclass/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-24.11 bash 2>&1 | tee /tmp/infect.log
```
## Important Notes
Execution Halts on Errors: Any errors will stop the process to prevent further inconsistencies.

## Acknowledgements
We extend our gratitude to [@elitak](https://github.com/elitak/) for their original work on [nixos-infect](https://github.com/elitak/nixos-infect), which inspired this version.
