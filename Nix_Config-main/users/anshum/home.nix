{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home/terminal/kitty.nix
    ../../modules/home/terminal/bash.nix
    ../../modules/home/desktop/theme.nix
    ../../modules/home/desktop/default.nix
    ../../modules/home/apps/default.nix
  ];

  home.username = (import ./secrets.nix).username;
  home.homeDirectory = "/home/${(import ./secrets.nix).username}";
  home.stateVersion = (import ./secrets.nix).stateVersion;
}
