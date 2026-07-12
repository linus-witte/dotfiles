{
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
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  environment.shellAliases = {
    nrb = "(cd $HOME/dotfiles/nixos && nixos-rebuild build --flake path:$HOME/dotfiles/nixos#nixos && result/sw/bin/nvd diff /run/current-system result && nixos-rebuild switch --sudo --no-reexec --store-path $(readlink -f result))";
    sleep-inhibit = "$HOME/.config/i3status/sleep_delay.sh prompt";
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
