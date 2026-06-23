{ lib, ... }:

{
  imports = lib.optional (builtins.pathExists ./filesystems.local.nix) ./filesystems.local.nix;

  # Example local CIFS mount. Put real mounts in ./filesystems.local.nix, which is
  # gitignored, and keep credentials outside the repository.
  #
  # fileSystems."/mnt/share" = {
  #   device = "//server/share";
  #   fsType = "cifs";
  #   options = [
  #     "credentials=/etc/samba/credentials/share"
  #     "uid=1000"
  #     "gid=1000"
  #     "_netdev"
  #     "nofail"
  #     "x-systemd.automount"
  #   ];
  # };
}
