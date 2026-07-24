{
  lib,
  pkgs,
  pkgsUnstable,
  pkgsJellyfinMediaPlayer,
  ...
}:

let
  superProductivityMcp = pkgsUnstable.buildNpmPackage rec {
    pname = "super-productivity-mcp";
    version = "1.3.3";

    src = pkgsUnstable.fetchFromGitHub {
      owner = "b0x42";
      repo = "Super-Productivity-MCP";
      rev = "v${version}";
      hash = "sha256-Gs2Ft9YgSTHLDbTnUbOknCOeXB5mTyjOqCxnPIb58X8=";
    };

    npmDepsHash = "sha256-vTVIyTicmD0mJ1DgyuZqQmu6TzBeiY6q50zkvs5bKoo=";
    nativeBuildInputs = [ pkgsUnstable.zip ];

    meta = {
      description = "MCP server for Super Productivity";
      homepage = "https://github.com/b0x42/Super-Productivity-MCP";
      license = lib.licenses.mit;
      mainProgram = "super-productivity-mcp";
    };
  };

  jellyfinMediaPlayer = pkgs.symlinkJoin {
    name = "jellyfin-media-player-x11";
    paths = [ pkgsJellyfinMediaPlayer.jellyfin-media-player ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/jellyfinmediaplayer \
        --set QT_QPA_PLATFORM xcb \
        --set QT_XCB_GL_INTEGRATION xcb_glx
    '';
  };

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
    jellyfinMediaPlayer
    freshfetch
    libreoffice
    anki
    pawn-appetit
    zathura
    super-productivity
    handbrake
    mattermost-desktop
    zotero
  ];

  unstableDevelopmentPackages = with pkgsUnstable; [
    superProductivityMcp
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
    nfu = "nix flake update --flake path:$HOME/dotfiles/nixos";
    nrb = "(cd $HOME/dotfiles/nixos && nixos-rebuild build --flake path:$HOME/dotfiles/nixos#nixos && result/sw/bin/nvd diff /run/current-system result && nixos-rebuild switch --sudo --no-reexec --store-path $(readlink -f result))";
    sleep-inhibit = "$HOME/.config/i3status/sleep_delay.sh prompt";
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
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
