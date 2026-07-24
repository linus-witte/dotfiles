{ ... }:

{
  services.desktopManager.plasma6.enable = true;

  # Plasma defaults SDDM's greeter to Wayland. Its handoff to the X11 i3
  # session times out, so keep only the greeter on X11. Plasma Wayland remains
  # available as a desktop session.
  services.displayManager.sddm.wayland.enable = false;
}
