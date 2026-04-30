#!/usr/bin/env bash

get_window() {
    title=$(hyprctl activewindow -j | jq -r '.title // empty')
    if [ -z "$title" ]; then
        echo ""
    else
        if [ ${#title} -gt 50 ]; then
            echo "${title:0:47}..."
        else
            echo "$title"
        fi
    fi
}

get_window

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    case "$line" in
        activewindow*)
            get_window
            ;;
    esac
done
