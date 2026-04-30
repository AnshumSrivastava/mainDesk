{ config, pkgs, ... }:

let
  rofi-runner = pkgs.writeShellScriptBin "rofi-runner" ''
    # Elephant Application Runner via Rofi (Dynamic fallback to drun)
    # Using native drun for fresh data every time
    ${pkgs.rofi}/bin/rofi -show drun -display-drun "  sys.run"
  '';

  rofi-clipboard = pkgs.writeShellScriptBin "rofi-clipboard" ''
    # Elephant Clipboard History via Rofi

    # Query elephant for clipboard
    clips=$(${pkgs.elephant}/bin/elephant query --json "clipboard;;50" | ${pkgs.jq}/bin/jq -s -c '.')
    # Clean up newlines for rofi display
    display_list=$(echo "$clips" | ${pkgs.jq}/bin/jq -r '.[].item.text | gsub("\n"; " ")')

    # Show rofi and get selection index
    choice=$(echo "$display_list" | ${pkgs.rofi}/bin/rofi -dmenu -i -p "  sys.mem" -format i)

    if [ -n "$choice" ]; then
        id=$(echo "$clips" | ${pkgs.jq}/bin/jq -r ".[$choice].item.identifier")
        ${pkgs.elephant}/bin/elephant activate "clipboard;$id;copy;;"
    fi
  '';

  rofi-emojis = pkgs.writeShellScriptBin "rofi-emojis" ''
    # Elephant Emoji/Symbol Picker via Rofi

    # Query elephant for symbols
    symbols=$(${pkgs.elephant}/bin/elephant query --json "symbols;;300" | ${pkgs.jq}/bin/jq -s -c '.')
    display_list=$(echo "$symbols" | ${pkgs.jq}/bin/jq -r '.[].item | "\(.icon) \(.text)"')

    # Show rofi and get selection index
    choice=$(echo "$display_list" | ${pkgs.rofi}/bin/rofi -dmenu -i -p "󰇵  sys.sym" -format i)

    if [ -n "$choice" ]; then
        id=$(echo "$symbols" | ${pkgs.jq}/bin/jq -r ".[$choice].item.identifier")
        ${pkgs.elephant}/bin/elephant activate "symbols;$id;run_cmd;;"
    fi
  '';

  random-wallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
    # Set random wallpaper from the specified directory
    WALLPAPER_DIR="/mnt/Storage/Pictures/Wallpapers/PC"
    
    # Ensure daemon is running
    ${pkgs.swww}/bin/swww-daemon --format xrgb &
    
    # Wait for daemon to start
    # We use a loop to check if the daemon is ready
    while ! ${pkgs.swww}/bin/swww query; do
        sleep 0.5
    done

    # Select random wallpaper
    # -L to follow symlinks if any
    # shuf -n 1 to pick one random line
    WALLPAPER=$(find -L "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

    if [ -n "$WALLPAPER" ]; then
        ${pkgs.swww}/bin/swww img "$WALLPAPER" --transition-type outer --transition-pos top-right --transition-duration 2
    fi
  '';
in
{
  home.packages = [
    rofi-runner
    rofi-clipboard
    rofi-emojis
    random-wallpaper
  ];
}
