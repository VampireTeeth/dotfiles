#!/usr/bin/env bash

bluetooth_print() {
    if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then
        if bluetoothctl show | grep -q "Powered: yes"; then
            devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
            device_connected=""

            for device in $devices_paired; do
                if bluetoothctl info "$device" | grep -q "Connected: yes"; then
                    device_connected=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)
                    break
                fi
            done

            if [ -n "$device_connected" ]; then
                # Output the connected device name with an icon
                echo " $device_connected"
            else
                # Output a generic Bluetooth icon if powered on but nothing connected
                echo ""
            fi
        fi
    else
        # Output an icon indicating Bluetooth service is off
        echo "   Off"
    fi
}

bluetooth_print
