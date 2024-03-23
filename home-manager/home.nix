# home-manager configuration file
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Import other home-manager modules
  imports = [
    inputs.nix-colors.homeManagerModule

    # TODO: Split up my configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # TODO: Add overlays here
    overlays = [
    
    ];
    # Configure nixpkgs instance
    config = {
      # Allow unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "lasse";
    homeDirectory = "/home/lasse";
  };

  # TODO: Add stuff for my user
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    brave
    alacritty
    vscode
    bitwarden
    phoronix-test-suite
    perl
    libxml2
    bc
    bison
    flex
    openssl
    gmp
    cmake
    yasm
    nasm
    curl
    libuuid
    bzip2
    zlib
    scons
    ncurses
    rustc
    meson
    glew
    xorg.xorgserver
    protobuf
    boost
    tcl
    zlib
    libpng12
    p7zip
    libtool
    libaio
    monaspace
    starship
    (python3.withPackages (ps:
      with ps; [
        pip
        virtualenv
    ]))
    pipenv
    ruff
    ruff-lsp
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
