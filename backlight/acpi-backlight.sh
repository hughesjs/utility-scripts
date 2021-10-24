#! /bin/bash

CURR_BRIGHTNESS=/sys/class/backlight/amdgpu_bl0/brightness;
MAX_BRIGHTNESS=/sys/class/backlight/amdgpu_bl0/max_brightness;

MIN_ICON="notification-display-brightness-off";
LOW_ICON="notification-display-brightness-low";
MED_ICON="notification-display-brightness-medium";
HIGH_ICON="notification-display-brightness-full";

current_val=$(<$CURR_BRIGHTNESS);
max_val=$(<$MAX_BRIGHTNESS);

# Update Brightness
while getopts "i:d:" opt # get options for -a and -b ( ':' - option has an argument )
do
  case $opt in
      i) echo "Incrementing brightness...";
        new_val=$(("$current_val" + "$OPTARG"));
        if (("$new_val" > "$max_val")); then
          echo "Cannot increase past maximum brightness. Clamping to $max_val...";
          new_val=$max_val;
        fi
        echo "Setting brightness to $new_val";
        echo "$new_val" > $CURR_BRIGHTNESS;
        ;;
      d) echo "Decrementing brightness..."
        new_val=$(("$current_val" - "$OPTARG"));
        if (("$new_val" < 10)); then
          echo "Cannot decrease below 10 for safety. Clamping...";
          new_val=10;
        fi
        echo "Setting brightness to $new_val";
        echo "$new_val" > $CURR_BRIGHTNESS;
        ;;
      *) echo "Invalid option $opt"
  esac
done

# Send Notification
new_brightness=$(<$CURR_BRIGHTNESS);

low_thresh=$(echo "0.3*$max_val" | bc);
med_thresh=$(echo "0.7*$max_val" | bc);
high_thresh=$max_val

icon="";

if [ 1 -eq "$(echo "$new_brightness <= 10" | bc)" ]; then
    icon=$MIN_ICON;
elif [ 1 -eq "$(echo "$new_brightness < $low_thresh" | bc)" ]; then
    icon=$LOW_ICON;
elif [ 1 -eq "$(echo "$new_brightness < $med_thresh" | bc)" ]; then
    icon=$MED_ICON;
else
    icon=$HIGH_ICON;
fi

notify-send "Brightness: $new_brightness/$max_val" --icon=$icon
notify-send $icon




