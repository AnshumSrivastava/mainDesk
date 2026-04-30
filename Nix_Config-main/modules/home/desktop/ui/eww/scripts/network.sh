#!/usr/bin/env bash

get_status() {
    state=$(nmcli -t -f STATE g 2>/dev/null)
    if [ "$state" = "connected" ]; then
        ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
        echo "{\"status\": \"connected\", \"ssid\": \"$ssid\", \"icon\": \"󰖩\"}"
    else
        echo "{\"status\": \"disconnected\", \"ssid\": \"Disconnected\", \"icon\": \"󰖪\"}"
    fi
}

get_status

nmcli monitor 2>/dev/null | while read -r line; do
    get_status
done
