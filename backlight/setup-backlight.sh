#! /bin/bash

CURR_BRIGHTNESS=/sys/class/backlight/amdgpu_bl0/brightness;
MAX_BRIGHTNESS=/sys/class/backlight/amdgpu_bl0/max_brightness;

# Check Sudo

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script needs to be run as root"
    exit
fi

# Setup Group

echo "Setting up backlight control group"

if [ "$(getent group backlight)" ]; then
  echo "Backlight group already exists"
else
  echo "Creating backlight group"
  groupadd backlight
fi

# Add Current User to Group

if groups "$USER" | grep -q 'backlight'; then
    echo "User already in backlight group"
else
    echo "Adding user to backlight group"
    usermod -aG backlight "$USER"
fi

# Set Owner

echo "Setting owner on ACPI files"

chown root:backlight $MAX_BRIGHTNESS
chown root:backlight $CURR_BRIGHTNESS

# Set Permissions

echo "Setting permissions on ACPI files"

chmod 444 $MAX_BRIGHTNESS
chmod 664 $CURR_BRIGHTNESS