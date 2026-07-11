{
  description = "Linus' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-jellyfin-media-player.url = "github:nixos/nixpkgs?ref=nixos-24.05";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-jellyfin-media-player,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          pkgsUnstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          pkgsJellyfinMediaPlayer = import nixpkgs-jellyfin-media-player {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./configuration.nix
        ];
      };
    };
}
