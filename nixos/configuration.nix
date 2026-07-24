{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./i3.nix
    ./hyprland.nix
    ./plasma.nix
    ./modules/desktop.nix
    ./modules/gaming.nix
    ./modules/packages.nix
    ./modules/services.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  # Keep this at the release used for the first install.
  system.stateVersion = "26.05";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.0.73" ];
  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = ''
    nameserver 192.168.0.73
    options edns0
  '';
  networking.firewall.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.linus = {
    isNormalUser = true;
    description = "Linus Witte";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Prevent systemd from auto-activating the stale GPT swap partition.
  systemd.generators.systemd-gpt-auto-generator = "/dev/null";

}
