#!/usr/bin/env bash

status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ] || [ "$status" = "Paused" ]; then
    title=$(playerctl metadata --format '{{title}}' 2>/dev/null)
    
    if [ "$status" = "Playing" ]; then
        icon="󰎈"
    else
        icon="󰏤"
    fi
    
    if [ ${#title} -gt 25 ]; then
        title="${title:0:22}..."
    fi
    
    echo "{\"show\": true, \"status\": \"$status\", \"title\": \"$title\", \"icon\": \"$icon\"}"
else
    echo "{\"show\": false}"
fi
