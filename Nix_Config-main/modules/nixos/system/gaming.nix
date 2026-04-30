/*
{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    package = pkgs.steam.override {
      extraBwrapArgs = [
        # Resurrect the dead symlink /etc/ssl/certs -> /.host-etc/ssl/certs
        "--bind" "/etc/static/ssl/certs" "/.host-etc/ssl/certs"
      ];
    };

    # Extra packages sometimes needed for proper functioning of certain games
    extraPackages = with pkgs; [
      nss
      nspr
      p11-kit
      attr
      curl
      openssl
      cacert
      libunwind
      libusb1
      nss_latest
    ];
  };

  # Network MTU Fix for "HTTP error 0" (Fragmentation issues)
  networking.interfaces.wlp2s0.mtu = 1280;

  programs.gamemode.enable = true;

  security.pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];

  # Enable 32-bit support (required for Steam)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    cacert
    steam-run
    steamcmd
    mangohud
    protonup-qt
    lutris
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    SSL_VIDEODRIVER = "wayland,x11";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";
    STEAM_FORCE_IPV4 = "1";
    GODEBUG = "netdns=cgo";
  };
}
*/

