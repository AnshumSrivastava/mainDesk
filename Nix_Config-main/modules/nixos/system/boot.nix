{ config, pkgs, ... }:

let
  themes = import ./boot-themes { inherit pkgs; };
in
{
  boot.loader.grub = {
    theme = "${themes.progeta-grub}/grub/themes/progeta";
  };

  boot.plymouth = {
    enable = true;
    themePackages = [ themes.progeta-plymouth ];
    theme = "progeta";
  };
}
