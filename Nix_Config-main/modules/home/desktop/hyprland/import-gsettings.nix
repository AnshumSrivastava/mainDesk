{ config, pkgs, ... }:

let
  import-gsettings = pkgs.writeShellScriptBin "import-gsettings" ''
    # Sync GTK themes and dark mode preferences with gsettings
    # This is necessary for Hyprland to apply themes to GTK applications
    
    config="${config.home.homeDirectory}/.config/gtk-4.0/settings.ini"
    if [ -f "$config" ]; then
      gtk_theme=$(grep "gtk-theme-name" "$config" | cut -d'=' -f2)
      icon_theme=$(grep "gtk-icon-theme-name" "$config" | cut -d'=' -f2)
      cursor_theme=$(grep "gtk-cursor-theme-name" "$config" | cut -d'=' -f2)
      
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"
      ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
    fi
    
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
  '';
in
{
  home.packages = [ import-gsettings ];
}
