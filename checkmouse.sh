#!/bin/bash
# Creates an OSX popup window if magic mouse battery drops below %25
# ericwhyne at datamachines d0t com
# Add this to crontab: 0 7 * * * /path/to/this/script.sh
NOTIFY_FILE="/tmp/mouse_battery_low"
export DISPLAY=:0
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
battery_level=$(ioreg -c AppleDeviceManagementHIDEventService -r | \
  grep -i '"BatteryPercent" =' | awk '{print $NF}' | head -n 1)
echo "Mouse Battery level: $battery_level"
if [ "$battery_level" -lt 25 ]; then
    if [ ! -f "$NOTIFY_FILE" ]; then
        touch "$NOTIFY_FILE"
        sync
        osascript -e "display dialog \"Mouse battery low: $battery_level%.\" \
                      with title \"Low Battery Warning\" \
                      buttons {\"OK\"} \
                      default button \"OK\"" > /dev/null 2>&1 &
    fi
else
    [ -f "$NOTIFY_FILE" ] && rm "$NOTIFY_FILE"
fi
