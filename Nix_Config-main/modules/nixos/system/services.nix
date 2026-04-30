{ config, pkgs, inputs, ... }:

{
  # Time Synchronization
  # services.timesyncd.enable = true; # Handled in configuration.nix

  # Networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # Enable udisks2 for GNOME Disks and automatic mounting
  services.udisks2.enable = true;

  # DNS Configuration via NextDNS
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = let
        vars = import ../../../variables.nix;
      in (builtins.concatStringsSep " " vars.dnsServers);
      DNSOverTLS = (import ../../../variables.nix).dnsOverTLS;
      DNSSEC = "true";
      Domains = [ "~." ];
      FallbackDNS = [ "1.1.1.1" "8.8.8.8" ];
    };
  };

  # Tailscale
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--accept-dns=false" ];
  };

  # Tor
  services.tor = {
    enable = true;
    client.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # Wireplumber is enabled by default, but we can be explicit
    wireplumber.enable = true;
  };

  # Syncthing
  # services.syncthing = {
  #   enable = true;
  #   user = "anshum";
  #   dataDir = "/home/anshum/Documents";
  #   configDir = "/home/anshum/.config/syncthing";
  # };
}
