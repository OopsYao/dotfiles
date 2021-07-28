#!/usr/bin/env bash
# https://gitlab.com/jD91mZM2/xidlehook#example

# lock.sh needs this
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"
# Only the canceller of the current timer period will be executed
# at the end of idle.
# e.g., the second canceller will be executed only if
# idle ends between the start time of the second timer
# and the third one.
canceller='dim_screen.py brighten'

# Run xidlehook
xidlehook \
  --detect-sleep \
  --not-when-fullscreen \
  --not-when-audio \
  `# Dim the screen after 300 seconds, undim if user becomes active` \
  --timer 300 \
    'dim_screen.py' \
    "$canceller" \
  `# Undim & lock after 120 more seconds` \
  --timer 120 \
    'lock.sh' \
    "$canceller" \
  `# Suspend after 180 more seconds` \
  --timer 180 \
    'systemctl suspend' \
    "$canceller"
