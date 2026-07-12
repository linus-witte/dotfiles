{ ... }:

{
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb = {
      layout = "us";
      variant = "colemak_dh";
    };
  };

  # Reuse the XKB layout on TTYs so Colemak-DH is consistent before login.
  console.useXkbConfig = true;

  services.displayManager = {
    sddm.enable = true;
    defaultSession = "none+i3";
  };

  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.dconf.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
