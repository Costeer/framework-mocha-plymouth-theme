{
  description = "A plymouth theme for the framework laptop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      mkFrameworkTheme =
        pkgs:
        pkgs.stdenv.mkDerivation rec {
          pname = "framework-mocha-plymouth-theme";
          version = "0.1.0";

          src = ./.;

          buildInputs = [ pkgs.plymouth ];

          installPhase = ''
            runHook preInstall

            install -d -m 0755 $out/share/plymouth/themes/framework
            cp -r ./framework/* $out/share/plymouth/themes/framework

            # Fix the path references in the plymouth configuration
            substituteInPlace $out/share/plymouth/themes/framework/framework.plymouth \
              --replace "ImageDir=/usr/share/plymouth/themes/framework" "ImageDir=$out/share/plymouth/themes/framework"

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Plymouth theme with animated Framework logo";
            homepage = "https://github.com/costeer/framework-mocha-plymouth-theme";
            license = licenses.mit;
            platforms = platforms.linux;
            maintainers = [ ];
          };
        };
    in
    {
      # Package outputs for direct installation
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = mkFrameworkTheme pkgs;
          framework-mocha-plymouth-theme = mkFrameworkTheme pkgs;
        }
      );

      # Overlay for adding the package to nixpkgs
      overlays.default = final: prev: {
        framework-mocha-plymouth-theme = mkFrameworkTheme final;
      };

      # NixOS module for easy integration
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        with lib;
        let
          cfg = config.boot.plymouth.framework-mocha;
        in
        {
          options.boot.plymouth.framework-mocha = {
            enable = mkEnableOption "Framework Mocha Plymouth theme";
          };

          config = mkIf cfg.enable {
            boot.plymouth = {
              enable = true;
              theme = "framework";
              themePackages = [ (mkFrameworkTheme pkgs) ];
            };
          };
        };

      # Alternative NixOS module that just provides the theme without enabling it
      nixosModules.theme =
        { pkgs, ... }:
        {
          boot.plymouth.themePackages = [ (mkFrameworkTheme pkgs) ];
        };
    };
}
