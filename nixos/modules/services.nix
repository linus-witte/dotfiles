{ ... }:

{
  # Membership in the docker group is root-equivalent.
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  services.openssh = {
    enable = true;
    # SSH remains enabled, but only with key-based non-root logins.
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.tailscale.enable = true;
  services.printing.enable = true;
}
