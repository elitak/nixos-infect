{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    # Including this by default now to avoid potential problems with missing kernel modules
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
  ];
  boot.loader.grub.device = "/dev/sda";
  networking.useDHCP = false;
  networking.enableIPv6 = false;
  networking.interfaces.ens3.useDHCP = false;
  networking.defaultGateway = "169.254.0.1";
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.interfaces.ens3 = {
    ipv4.addresses = [
      { address = "1.2.3.4"; prefixLength = 32; } # Primary IP
      { address = "1.2.3.5"; prefixLength = 32; } # Secondary IP
    ];
    ipv4.routes = [{
      address = "169.254.0.1";  # IP of the gateway
      prefixLength = 32;
    }];
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
  };

  # Set initial root password in case we need to use the rescue console.
  # IMPORTANT: change the password!
  users.users.root.initialPassword = "secret";

  # IMPORTANT: replace with your own key(s)!
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAAD..."
  ];

  system.stateVersion = "21.05";
}
