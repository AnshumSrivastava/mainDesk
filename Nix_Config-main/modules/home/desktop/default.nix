{ config, pkgs, ... }:

{
  imports = [
    ./rofi.nix
    ./scripts.nix
    ./swaync.nix
    ./hyprland/import-gsettings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = builtins.readFile ./hyprland/hyprland.conf;
  };

  programs.eww = {
    enable = true;
    configDir = ./ui/eww;
  };
}
