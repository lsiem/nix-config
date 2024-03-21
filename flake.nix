{
  description = "Lasse's personal nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Additional flakes
    hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      herobox-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # main nixos configuration file
        modules = [./nixos/configuration.nix];
      };
    };
  };
}
