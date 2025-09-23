# Framework Plymouth Theme

Catppuccin Mocha variant of [James Kupke's Framework plymouth theme](https://git.sr.ht/~jameskupke/framework-plymouth-theme)

Artwork credit to sniss https://community.frame.work/t/framework-fan-art/6626/39

## Installation

```nix
# configuration.nix
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.enable = true;
    kernelParams = [ "quiet" ];

    plymouth = {
      enable = true;
      theme = "framework";
    };
  };
```

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    framework-plymouth.url = "github:Costeer/framework-mocha-plymouth-theme";
  };

  outputs = {
    self,
    nixpkgs,
    framework-plymouth,
    ...
  }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        framework-plymouth.nixosModules.default

      ];
    };
  };
}
```
