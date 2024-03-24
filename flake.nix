{
  description = "Lasse's personal nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    nix-alien.url = "github:thiagokokada/nix-alien";
  };

  outputs = { self, nixpkgs, home-manager, hardware, nix-colors, nixos-conf-editor, nix-alien, ... } @ inputs: {
    nixosConfigurations = {
      herobox-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./nixos/configuration.nix ];
      };
    };
    homeConfigurations = {
      lasse = home-manager.lib.homeManagerConfiguration {
        configuration = { config, pkgs, ... }: {
          imports = [
          ];
          programs.home-manager.enable = true;
          environment.systemPackages = with pkgs; [
            libxslt
            inputs.nix-alien
          ];
        };
        # Pass nix-alien and other inputs to Home Manager
        specialArgs = { inherit inputs; };
        nixpkgs = inputs.nixpkgs;
        home-manager = inputs.home-manager;
        nix-alien = inputs.nix-alien;
      };
    };
  };
}
