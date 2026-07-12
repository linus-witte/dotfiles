{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
        i3status
        rofi
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    dunst
    feh
    xclip
    xrandr
    xss-lock
  ];
}
