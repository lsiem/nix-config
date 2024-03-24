{
  description = "nix-alien-on-nixos";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.nix-alien.url = "github:thiagokokada/nix-alien";

  outputs = { self, nixpkgs, nix-alien }: {
      nixosConfigurations.nix-alien-desktop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux"; # or aarch64-linux
        specialArgs = { inherit self system; };
        modules = [
          ({ self, system, ... }: {
            environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
              nix-alien
            ];
            # Optional, needed for `nix-alien-ld`
            programs.nix-ld.enable = true;
          })
        ];
    };
  };
}
