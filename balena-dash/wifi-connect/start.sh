#!/usr/bin/env bash

# Check if service has been disabled through the DISABLED_SERVICES environment variable.

if [[ ",$(echo -e "${DISABLED_SERVICES}" | tr -d '[:space:]')," = *",$BALENA_SERVICE_NAME,"* ]]; then
        echo "$BALENA_SERVICE_NAME is manually disabled."
        sleep infinity
fi

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

sleep 10
while [[ true ]]; do
  # Choose a condition for running WiFi Connect according to your use case:

  # 1. Is there a default gateway?
  # ip route | grep default

  # 2. Is there Internet connectivity?
  # nmcli -t g | grep full

  # 3. Is there Internet connectivity via a google ping?
  wget --spider http://google.com >/dev/null 2>&1

  # 4. Is there an active WiFi connection?
  # iwgetid -r

  if [ $? -ne 0 ]; then
      printf 'Starting WiFi Connect\n'
      # Start wifi-connect with SSID "balenaDash", Password "balenaDash" and make it exit if no interaction happens within 10 minutes.
      ./wifi-connect -a 600 -s balenaWiFi -p balenaWiFi -o 8181
  fi
  # wait 1 minute before checking again for internet connectivity
  sleep 60
done
