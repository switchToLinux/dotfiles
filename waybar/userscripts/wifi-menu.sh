#!/usr/bin/env bash

# Author: Jesse Mirabel (@sejjy)
# GitHub: https://github.com/sejjy/mechabar

options=$(
  echo "  Manual Entry"
  echo "󰤮  Disable Wi-Fi"
)
option_disabled="󰤥  Enable Wi-Fi"

# Prompt for password
get_password() {
  wofi --password --dmenu -p " " || pkill -x wofi
}

while true; do
  wifi_list() {
    nmcli --fields "SECURITY,SSID" device wifi list |
      tail -n +2 |               # Skip the header line from nmcli output
      sed 's/  */ /g' |          # Replace multiple spaces with a single space
      sed -E "s/WPA*.?\S/󰤪 /g" | # Replace 'WPA*' with a Wi-Fi lock icon
      sed "s/^--/󰤨 /g" |         # Replace '--' (open networks) with an open Wi-Fi icon
      sed "s/󰤪  󰤪/󰤪/g" |         # Remove duplicate Wi-Fi lock icons
      sed "/--/d" |              # Remove lines containing '--' (empty SSIDs)
      awk '!seen[$0]++'          # Filter out duplicate SSIDs
  }

  # Get Wi-Fi status
  wifi_status=$(nmcli -fields WIFI g)

  case "$wifi_status" in
  *"enabled"*)
    selected_option=$(echo "$options"$'\n'"$(wifi_list)" |
      wofi --dmenu -p " " || pkill -x wofi)
    ;;
  *"disabled"*)
    selected_option=$(echo "$option_disabled" |
      wofi --dmenu -theme-str "${override_disabled}" || pkill -x wofi)
    ;;
  esac

  # Extract selected SSID
  read -r selected_ssid <<<"${selected_option:3}"

  # Actions based on selected option
  case "$selected_option" in
  "")
    exit
    ;;
  *"Enable Wi-Fi")
    notify-send "Scanning for networks..." -i "package-installed-outdated"
    nmcli radio wifi on
    nmcli device wifi rescan
    sleep 3
    ;;
  *"Disable Wi-Fi")
    notify-send "Wi-Fi Disabled" -i "package-broken"
    nmcli radio wifi off
    exit
    ;;
  *"Manual Entry")
    # Prompt for SSID
    manual_ssid=$(wofi --dmenu -p " " || pkill -x wofi)

    # Exit if no option is selected
    if [ -z "$manual_ssid" ]; then
      exit
    fi

    # Prompt for Wi-Fi password
    wifi_password=$(get_password)

    if [ -z "$wifi_password" ]; then
      # Without password
      if nmcli device wifi connect "$manual_ssid" | grep -q "successfully"; then
        notify-send "Connected to \"$manual_ssid\"." -i "package-installed-outdated"
        exit
      else
        notify-send "Failed to connect to \"$manual_ssid\"." -i "package-broken"
      fi
    else
      # With password
      if nmcli device wifi connect "$manual_ssid" password "$wifi_password" | grep -q "successfully"; then
        notify-send "Connected to \"$manual_ssid\"." -i "package-installed-outdated"
        exit
      else
        notify-send "Failed to connect to \"$manual_ssid\"." -i "package-broken"
      fi
    fi
    ;;
  *)
    # Get saved connections
    saved_connections=$(nmcli -g NAME connection)

    if echo "$saved_connections" | grep -qw "$selected_ssid"; then
      if nmcli connection up id "$selected_ssid" | grep -q "successfully"; then
        notify-send "Connected to \"$selected_ssid\"." -i "package-installed-outdated"
        exit
      else
        notify-send "Failed to connect to \"$selected_ssid\"." -i "package-broken"
      fi
    else
      # Handle secure network connection
      if [[ "$selected_option" =~ ^"󰤪" ]]; then
        wifi_password=$(get_password)
      fi

      if nmcli device wifi connect "$selected_ssid" password "$wifi_password" | grep -q "successfully"; then
        notify-send "Connected to \"$selected_ssid\"." -i "package-installed-outdated"
        exit
      else
        notify-send "Failed to connect to \"$selected_ssid\"." -i "package-broken"
      fi
    fi
    ;;
  esac
done