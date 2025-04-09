#!/bin/bash

BOSE="4C:87:5D:81:CE:65"
MOUSE="E3:CD:E9:21:88:17"    

refresh_device() {
    local device_mac=$1
    local device_name=$2
    
    echo "Refreshing connection for $device_name ($device_mac)..."
    
    echo "Disconnecting $device_name..."
    bluetoothctl disconnect $device_mac
    sleep 2
    
    echo "Connecting $device_name..."
    bluetoothctl connect $device_mac
    
    if bluetoothctl info $device_mac | grep -q "Connected: yes"; then
        echo "$device_name connected successfully."
    else
        echo "Warning: $device_name may not have connected properly."
    fi
    
    echo "------------------------"
}

echo "Starting Bluetooth refresh script..."

refresh_device "$BOSE" "Headphones"

refresh_device "$MOUSE" "Mouse"

echo "Bluetooth refresh completed."
