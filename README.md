# Dotfiles

Personal NixOS and user configuration.

## Layout

- `nixos/`: system configuration copied into `/etc/nixos`
- `home/`: user configuration intended to be linked into `$HOME`

## Fresh NixOS setup

Install the NixOS config first so required tools such as `git`, `stow`, `tmux`,
`zsh`, and desktop utilities are available before linking user configs.

```sh
sudo install -m 0644 ~/dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

```sh
cd ~/dotfiles
stow home
```

Install tmux plugins after stowing `home`:

```sh
./scripts/bootstrap-tmux
```
