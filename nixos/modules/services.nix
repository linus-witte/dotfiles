{ ... }:

{
  # Membership in the docker group is root-equivalent.
  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };
  virtualisation.podman.enable = true;

  # Generate CDI device specifications for NVIDIA-enabled containers.
  hardware.nvidia-container-toolkit.enable = true;

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
