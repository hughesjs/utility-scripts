#! /bin/bash

CURR_BRIGHTNESS=/sys/class/backlight/amdgpu_bl0/brightness;
MAX_BRIGHTNESS=/sys/class/backlight/amdgpu_bl0/max_brightness;

current_val=$(<$CURR_BRIGHTNESS);
max_val=$(<$MAX_BRIGHTNESS);

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
