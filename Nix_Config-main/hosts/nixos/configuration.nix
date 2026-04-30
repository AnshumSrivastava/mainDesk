{ config, lib, pkgs, inputs, ... }:

{
  # imports
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/system/services.nix
    ../../modules/nixos/system/software.nix
    ../../modules/nixos/system/python-projects.nix
    ../../modules/nixos/desktop/hyprland.nix
    # ../../modules/nixos/system/gaming.nix
    ../../modules/nixos/system/boot.nix
    ../../modules/nixos/system/nodejs.nix
    ../../users/anshum/aliases.nix
  ];

  # Boot loader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # OBS Virtual Camera configuration is handled by programs.obs-studio

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Load variables (migrated to direct secrets imports)

  # User account
  users.users.${(import ../../users/anshum/secrets.nix).username} = {
    isNormalUser = true;
    enable = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
  };

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # State version
  system.stateVersion = (import ../../users/anshum/secrets.nix).stateVersion;

  # Time Zone
  time.timeZone = "Asia/Kolkata";

  # Environment Variables
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    PLAYWRIGHT_CHROME_EXECUTABLE_PATH = "/etc/profiles/per-user/anshum/bin/google-chrome-stable";
    CHROME_BIN = "/etc/profiles/per-user/anshum/bin/google-chrome-stable";
  };

  # Enable nix-ld for unpatched binaries (required for Playwright/Browser)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libxscrnsaver
    libXtst
    libdrm
    libnotify
    libuuid
    libxcb
    libxkbcommon
    libxshmfence
    mesa
    nspr
    nss
    pango
    pipewire
    systemd
    icu
    libusb1
    vulkan-loader
  ];

  # Display Manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      min_uid = 1000; # Hide system users
    };
  };

  # OBS Studio with Virtual Camera support
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  # XDG Portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Bind Mount User Directories
  fileSystems."/home/anshum/Downloads" = {
    device = "/mnt/Storage/UnCatogorized/Downloads";
    options = [ "bind" ];
  };
  fileSystems."/home/anshum/Documents" = {
    device = "/mnt/Storage/UnCatogorized/Documents";
    options = [ "bind" ];
  };
  fileSystems."/home/anshum/Music" = {
    device = "/mnt/Storage/UnCatogorized/Music";
    options = [ "bind" ];
  };
  fileSystems."/home/anshum/Pictures" = {
    device = "/mnt/Storage/UnCatogorized/Pictures";
    options = [ "bind" ];
  };
  fileSystems."/home/anshum/Videos" = {
    device = "/mnt/Storage/UnCatogorized/Videos";
    options = [ "bind" ];
  };
  fileSystems."/home/anshum/Desktop" = {
    device = "/mnt/Storage/UnCatogorized/Desktop";
    options = [ "bind" ];
  };
}
