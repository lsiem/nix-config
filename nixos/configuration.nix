# This is my system's configuration file.
# This is used to configure my system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Import other NixOS modules here
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  
    # Use modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-intel-kaby-lake
    inputs.hardware.nixosModules.common-pc-ssd
    
    # TODO: split up configuration and import pieces of it here:
    # ./users.nix
    ./modules/gnome.nix
    ./services/pipewire.nix
    ./services/backlight.nix
    ./services/power.nix
    ./modules/system/hardware/bluetooth.nix
    ./modules/system/hardware/nvidia.nix
    ./modules/system/hardware/intel.nix
    ./modules/system/security/security.nix
    ./modules/system/boot/boot.nix
    ./modules/system/hardware/opengl.nix

    ./modules/programs/starship.nix
    ../home-manager/zsh.nix

    # Import generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      users = {
        # Import my home-manager configuration
        lasse = import ../home-manager/home.nix;
      };
  };

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  nixpkgs = {
    # TODO: Add overlays here
    overlays = [
      # TODO: Use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
    ];
    # Configure nixpkgs instance
    config = {
      # Allow unfree packages
      allowUnfree = true;
    };
  };

  # Add each flake input as a registry which makes nix3 commands consistent with my flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # Additionally add my inputs to the system's legacy channels to make legacy nix commands consistent as well
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    # Trust only root and wheel group
    trusted-users = ["root" "lasse"];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-5ab49469-444a-47cf-a173-2e9f78321f22".device = "/dev/disk/by-uuid/5ab49469-444a-47cf-a173-2e9f78321f22";
  boot.initrd.availableKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "i915" ];
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "i915" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  networking.hostName = "herobox-nixos"; # Defines hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable nextdns
  services.nextdns.enable = true;

  services.resolved = {
    enable = true;
    extraConfig = "
      DNS=45.90.28.0#6a3414.dns.nextdns.io
      DNS=2a07:a8c0::#6a3414.dns.nextdns.io
      DNS=45.90.30.0#6a3414.dns.nextdns.io
      DNS=2a07:a8c1::#6a3414.dns.nextdns.io
      DNSOverTLS=yes
    ";
  };

  # Set my time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Set latitude and longitude
  location.latitude = 53.04;
  location.longitude = 8.28;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.accounts-daemon.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tumbler.enable = true;
  services.upower.enable = true;

  services.dbus = {
      enable = true;
      implementation = "broker";
      packages = with pkgs; [dconf gcr udisks2];
  };

  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon android-udev-rules];

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define my user account
  users.users.lasse = {
    isNormalUser = true;
    description = "Lasse";
    shell = pkgs.zsh;
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "adbusers"
      "input"
      "networkmanager"
      "plugdev"
      "transmission"
      "video"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      firefox
    ];
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${system}.default
    inputs.nixos-conf-editor.packages.${system}.nixos-conf-editor
    wget
    micro
    git
    zsh
    ocs-url
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable zsh
  programs.zsh.enable = true;

  # List services that I want to enable:
  # TODO: Add services


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
