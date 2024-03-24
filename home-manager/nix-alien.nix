{
  outputs = { self, nixpkgs, home-manager, nix-alien }:
    let
      system = "x86_64-linux"; # or aarch64-linux
      pkgs = import nixpkgs { inherit system; };
    in {
        homeConfigurations.nix-alien-home = home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          extraSpecialArgs = { inherit self system; };
          modules = [
            ({ self, system, ... }: {
              home.packages = with self.inputs.nix-alien.packages.${system}; [
                nix-alien
              ];
            })
          ];
      };
    };
}
