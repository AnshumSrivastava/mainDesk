{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 24;
    };
    settings = {
      window_padding_width = "10";
      background_opacity = "0.9";
      confirm_os_window_close = 0;
      foreground = "#eff0f1";
      background = "#232629";
      selection_background = "#3daee9";
      selection_foreground = "#eff0f1";
      cursor = "#eff0f1";
      cursor_text_color = "#232629";
      color0 = "#1b1e20";
      color8 = "#232627";
      color1 = "#ed1515";
      color9 = "#c0392b";
      color2 = "#11d116";
      color10 = "#1cdc9a";
      color3 = "#f67400";
      color11 = "#fdbc4b";
      color4 = "#1d99f3";
      color12 = "#3daee9";
      color5 = "#9b59b6";
      color13 = "#8e44ad";
      color6 = "#1abc9c";
      color14 = "#16a085";
      color7 = "#fcfcfc";
      color15 = "#ffffff";
    };
  };
}
