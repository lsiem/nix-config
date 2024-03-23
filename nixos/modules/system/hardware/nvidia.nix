{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf versionOlder;

  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;
  nvidiaPackage =
    if (versionOlder nvBeta nvStable)
    then config.boot.kernelPackages.nvidiaPackages.stable
    else config.boot.kernelPackages.nvidiaPackages.beta;

in {
  config = {
    boot.blacklistedKernelModules = ["nouveau"];
    hardware.nvidia = {
      powerManagement.enable = true;
      modesetting.enable = true;
      package = nvidiaPackage;
    };
    services.xserver.videoDrivers = ["nvidia"];
    nixpkgs.config.allowUnfree = true;

    # Enable support for Nvidia in Wayland sessions
    environment.variables.__EGL_VENDOR_LIBRARY_DIRS = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d";
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.displayManager.gdm.enable = true;
  };
}