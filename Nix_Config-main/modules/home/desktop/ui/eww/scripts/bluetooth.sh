#!/usr/bin/env bash

get_status() {
    power=$(bluetoothctl show 2>/dev/null | grep "Powered:" | awk '{print $2}')
    if [ "$power" = "yes" ]; then
        # Check if any device is connected
        device=$(bluetoothctl info 2>/dev/null | grep "Name:" | awk -F': ' '{print $2}')
        if [ -n "$device" ]; then
            echo "{\"status\": \"connected\", \"device\": \"$device\", \"icon\": \"󰂱\"}"
        else
            echo "{\"status\": \"on\", \"device\": \"On\", \"icon\": \"󰂯\"}"
        fi
    else
        echo "{\"status\": \"off\", \"device\": \"Off\", \"icon\": \"󰂲\"}"
    fi
}

get_status
