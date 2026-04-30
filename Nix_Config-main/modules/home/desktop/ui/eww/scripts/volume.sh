#!/usr/bin/env bash

get_vol() {
    vol=$(pamixer --get-volume 2>/dev/null)
    mute=$(pamixer --get-mute 2>/dev/null)
    if [ "$mute" = "true" ]; then
        echo "{\"vol\": \"$vol\", \"icon\": \"󰝟\"}"
    elif [ -z "$vol" ]; then
        # pamixer failed, default to 0
        echo "{\"vol\": \"0\", \"icon\": \"󰕿\"}"
    elif [ "$vol" -eq 0 ]; then
         echo "{\"vol\": \"0\", \"icon\": \"󰕿\"}"
    elif [ "$vol" -lt 50 ]; then
         echo "{\"vol\": \"$vol\", \"icon\": \"󰖀\"}"
    else
         echo "{\"vol\": \"$vol\", \"icon\": \"󰕾\"}"
    fi
}

get_vol

pactl subscribe 2>/dev/null | grep --line-buffered "Event 'change' on sink" | while read -r line; do
    get_vol
done
