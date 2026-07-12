{
  config,
  lib,
  pkgs,
  pkgsUnstable,
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
    nvd
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
    libreoffice
    anki
    pawn-appetit
    zathura
    super-productivity
    handbrake
  ];

  unstableDevelopmentPackages = with pkgsUnstable; [
    (stdenvNoCC.mkDerivation {
      pname = "codex";
      version = "0.144.1";

      src = fetchurl {
        url = "https://github.com/openai/codex/releases/download/rust-v0.144.1/codex-x86_64-unknown-linux-musl.tar.gz";
        hash = "sha256-hAka4gxl/MfUEg25fRvVfX/435x2Cft4HHjC671PWig=";
      };
      sourceRoot = ".";

      nativeBuildInputs = [
        installShellFiles
        makeWrapper
      ];

      installPhase = ''
        runHook preInstall
        install -Dm755 codex-x86_64-unknown-linux-musl $out/bin/codex
        wrapProgram $out/bin/codex --prefix PATH : ${
          lib.makeBinPath [
            ripgrep
            bubblewrap
          ]
        }
        installShellCompletion --cmd codex \
          --bash <($out/bin/codex completion bash) \
          --fish <($out/bin/codex completion fish) \
          --zsh <($out/bin/codex completion zsh)
        runHook postInstall
      '';

      meta = {
        description = "Lightweight coding agent that runs in your terminal";
        homepage = "https://github.com/openai/codex";
        license = lib.licenses.asl20;
        mainProgram = "codex";
      };
    })
    neovim
  ];

  unstableApplicationPackages = with pkgsUnstable; [
    unityhub
    discord
    jetbrains.rider
    spotify
    vscode
    proton-vpn
    obsidian
    zoom-us
  ];
in
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
    ./i3.nix
    ./hyprland.nix
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

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.shellAliases = {
    nrb = "(cd $HOME/dotfiles/nixos && nixos-rebuild build --flake path:$HOME/dotfiles/nixos#nixos && result/sw/bin/nvd diff /run/current-system result && nixos-rebuild switch --sudo --no-reexec --store-path $(readlink -f result))";
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
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
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
    desktopPackages
    ++ shellPackages
    ++ networkPackages
    ++ developmentPackages
    ++ applicationPackages
    ++ unstableDevelopmentPackages
    ++ unstableApplicationPackages;
}
