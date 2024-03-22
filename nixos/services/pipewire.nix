{ pkgs, lib, ... }: {
  # for pactl
  environment.systemPackages = with pkgs; [
    pulseaudio
    pamixer
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;
}
