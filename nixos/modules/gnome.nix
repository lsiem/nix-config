{ pkgs, ... }:

{
  # Configure X11 and GNOME
  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.gdm.enable = true;
    displayManager.defaultSession = "gnome";
    desktopManager.gnome.enable = true;
  };

  # Add gsconnect extension for mobile integration
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Install some useful GNOME extensions and tools
  environment.systemPackages = with pkgs; [
    playerctl # gsconnect play/pause control
    pamixer # gsconnect volume control
    gnome.gnome-tweaks
    gnome.dconf-editor 
    gnomeExtensions.gsconnect
    gnomeExtensions.pano
    gnomeExtensions.cpufreq
    gnomeExtensions.dark-variant
    gnomeExtensions.user-themes
    gnomeExtensions.arcmenu
    gnomeExtensions.vitals
    gnomeExtensions.forge
  ];
}
