{ config, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "#1e1e2e"; # Catppuccin Base
        text-color = mkLiteral "#cdd6f4"; # Catppuccin Text
        selected-background = mkLiteral "#313244"; # Catppuccin Surface0
        selected-text = mkLiteral "#f5e0dc"; # Catppuccin Rosewater
        accent-color = mkLiteral "#b4befe"; # Catppuccin Lavender
        border-color = mkLiteral "#45475a"; # Catppuccin Surface1
        font = mkLiteral ''"Inter 13"'';
      };

      "window" = {
        location = mkLiteral "north";
        anchor = mkLiteral "north";
        width = mkLiteral "100%";
        border = mkLiteral "0px 0px 1px 0px";
        border-color = mkLiteral "@border-color";
        padding = mkLiteral "0px";
        margin = mkLiteral "0px";
      };

      "mainbox" = {
        orientation = mkLiteral "horizontal";
        children = map mkLiteral [ "prompt" "entry" "listview" ];
        padding = mkLiteral "0px";
        spacing = mkLiteral "0px";
      };

      "prompt" = {
        text-color = mkLiteral "#ffffff";
        background-color = mkLiteral "#141414";
        padding = mkLiteral "10px 20px";
        font = mkLiteral ''"FiraCode Nerd Font Bold 13"'';
        border = mkLiteral "0px 1px 0px 0px";
        border-color = mkLiteral "@border-color";
      };

      "entry" = {
        expand = false;
        width = mkLiteral "16em";
        text-color = mkLiteral "@selected-text";
        background-color = mkLiteral "inherit";
        padding = mkLiteral "10px 20px";
        placeholder = mkLiteral ''"Search..."'';
        placeholder-color = mkLiteral "#333333";
      };

      "listview" = {
        layout = mkLiteral "horizontal";
        spacing = mkLiteral "0px";
        lines = 100;
        background-color = mkLiteral "inherit";
      };

      "element" = {
        padding = mkLiteral "8px 20px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "@text-color";
        border = mkLiteral "0px 0px 2px 0px";
        border-color = mkLiteral "transparent";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-background";
        text-color = mkLiteral "@selected-text";
        border = mkLiteral "0px 0px 2px 0px";
        border-color = mkLiteral "@accent-color";
      };
      
      "element-text" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };

      "element-icon" = {
        background-color = mkLiteral "inherit";
        size = mkLiteral "1.1em";
        padding = mkLiteral "0px 8px 0px 0px";
      };
    };
  };
}
