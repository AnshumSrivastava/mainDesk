{ config, pkgs, inputs, lib, ... }:

let
  update-system = pkgs.writeShellScriptBin "update-system" ''
    echo "Updating system inputs..."
    cd ~/nixos-config || exit 1
    nix flake update
    echo "Building and switching system..."
    sudo nixos-rebuild switch --flake .#nixos
  '';
in
{
  security.pki.installCACerts = true;

  environment.systemPackages = with pkgs; [
    update-system
    vim
    discord
    wget
    pavucontrol
    pamixer
    bluez
    blueman
    tailscale
    wayvnc
    tor
    openvpn
    mpv
    inkscape
    nautilus
    gnome-disk-utility
    ventoy
    adw-gtk3
    xvfb-run
    redis
    qt5.qtwayland
    qt6.qtwayland
    # Themes and Icons
    catppuccin-gtk
    papirus-icon-theme
    bibata-cursors
    adwaita-icon-theme
    hicolor-icon-theme
    flat-remix-gnome
    python3Packages.pyqt5
    # Using the flake version of antigravity
    inputs.antigravity.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-no-fhs
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
    "ventoy-1.1.10"
  ];

  fonts.packages = with pkgs; [
    # System & Symbol Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    material-design-icons
    
    # Maintain Nerd Fonts for icons
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.roboto-mono
    nerd-fonts.symbols-only
  ];
}
