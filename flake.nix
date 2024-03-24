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
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      herobox-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        # main nixos configuration file
        modules = [ ./nixos/configuration.nix ];
      };
    };
  };
}