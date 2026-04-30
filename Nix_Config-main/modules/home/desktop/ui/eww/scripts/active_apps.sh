#!/usr/bin/env bash

get_icon() {
    local class="${1,,}"
    case "$class" in
        *kitty*|*terminal*|*alacritty*) echo "" ;;
        *firefox*|*browser*|*chrome*|*brave*) echo "󰈹" ;;
        *code*|*vscode*|*vscodium*) echo "󰨞" ;;
        *discord*|*webcord*) echo "" ;;
        *spotify*) echo "" ;;
        *thunar*|*dolphin*|*files*|*nemo*) echo "" ;;
        *obsidian*) echo "󰎚" ;;
        *slack*) echo "" ;;
        *steam*) echo "󰓓" ;;
        *vlc*|*mpv*|*media*) echo "󰕼" ;;
        *) echo "" ;;
    esac
}

generate_json() {
    active_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    clients=$(hyprctl clients -j | jq -c 'map(select(.mapped == true)) | sort_by(.workspace.id)')
    
    json="["
    length=$(echo "$clients" | jq '. | length')
    
    for ((i=0; i<length; i++)); do
        client=$(echo "$clients" | jq -c ".[$i]")
        class=$(echo "$client" | jq -r '.class')
        workspace=$(echo "$client" | jq -r '.workspace.id')
        address=$(echo "$client" | jq -r '.address')
        icon=$(get_icon "$class")
        
        is_active="false"
        if [ "$workspace" == "$active_workspace" ]; then
            is_active="true"
        fi
        
        json+="{\"class\":\"$class\", \"workspace\":$workspace, \"address\":\"$address\", \"icon\":\"$icon\", \"is_active\":$is_active}"
        
        if [ $i -lt $((length - 1)) ]; then
            json+=","
        fi
    done
    json+="]"
    
    echo "$json"
}

generate_json

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    case "$line" in
        openwindow*|closewindow*|movewindow*|workspace*|focusedmon*)
            generate_json
            ;;
    esac
done
