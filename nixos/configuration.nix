{
  config,
  lib,
  pkgs,
  pkgsJellyfinMediaPlayer,
  ...
}:

let
  desktopPackages = with pkgs; [
    flameshot
    kitty
    libnotify
    networkmanagerapplet
    playerctl
    pavucontrol
    psmisc
    pulseaudio
  ];

  shellPackages = with pkgs; [
    bash
    zsh
    fzf
    nixfmt
    file
    yazi
    ripgrep
    fd
    htop
    btop
    ncdu
    tree
    unzip
    wget
    curl
    dnsutils
    rsync
    jq
    inxi
    lm_sensors
  ];

  networkPackages = with pkgs; [
    cifs-utils
    ntfs3g
    sshfs
    wireguard-tools
    openconnect
    networkmanager-openconnect
  ];

  developmentPackages = with pkgs; [
    # Project-specific compilers and runtimes belong in nix develop shells.
    git
    git-lfs
    github-cli
    delta
    stow
    vim
    codex
    neovim
    tmux
    tmux-sessionizer
    gnumake
    lua-language-server # For the neovim config
    bash-language-server
    poppler-utils
  ];

  applicationPackages = with pkgs; [
    firefox
    vlc
    pkgsJellyfinMediaPlayer.jellyfin-media-player
    freshfetch
    unityhub
    libreoffice
    discord
    jetbrains.rider
    anki
    pawn-appetit
    zathura
    spotify
    super-productivity
    vscode
    proton-vpn
    obsidian
    zoom-us
    handbrake
  ];
in
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./i3.nix
    ./hyprland.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  # Keep this at the release used for the first install.
  system.stateVersion = "26.05";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.shellAliases = {
    nrb = "sudo nixos-rebuild switch --flake path:$HOME/dotfiles/nixos#nixos";
    sleep-inhibit = "$HOME/.config/i3status/sleep_delay.sh prompt";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "colemak_dh";
  };

  # Reuse the XKB layout on TTYs so Colemak-DH is consistent before login.
  console.useXkbConfig = true;

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

  # Membership in the docker group is root-equivalent.
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "none+i3";

  # Prevent systemd from auto-activating the stale GPT swap partition.
  systemd.generators.systemd-gpt-auto-generator = "/dev/null";

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

  services.openssh.enable = true;
  # SSH remains enabled, but only with key-based non-root logins.
  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "no";
  };
  services.tailscale.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.printing.enable = true;
  programs.dconf.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };

  };

  environment.systemPackages =
    desktopPackages ++ shellPackages ++ networkPackages ++ developmentPackages ++ applicationPackages;
}
