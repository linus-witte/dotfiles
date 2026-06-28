# Dotfiles

Personal NixOS and user configuration.

## Layout

- `nixos/`: flake-based NixOS system configuration
- `home/`: user configuration intended to be linked into `$HOME`

## Fresh NixOS setup

Install the NixOS config first so required tools such as `git`, `stow`, `tmux`,
`zsh`, and desktop utilities are available before linking user configs.

```sh
sudo nixos-rebuild switch --flake path:$HOME/dotfiles/nixos#nixos
```

```sh
cd ~/dotfiles
stow home
```

Local filesystem mounts that should not be committed belong in `nixos/filesystems.local.nix`.
The tracked `nixos/filesystems.nix` contains a commented CIFS example and imports the local file when it exists.

CIFS credentials should live outside the repository, for example under `/etc/samba/credentials`, with root-only permissions.

Install tmux plugins after stowing `home`:

```sh
./scripts/bootstrap-tmux
```
