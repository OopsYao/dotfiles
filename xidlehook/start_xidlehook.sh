#!/usr/bin/env bash
# https://gitlab.com/jD91mZM2/xidlehook#example

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
  `# Dim the screen after 600 seconds, undim if user becomes active` \
  --timer 600 \
    'dim_screen.py' \
    "$canceller" \
  `# Suspend after 60 more seconds` \
  --timer 60 \
    'sleep_on_low_cpu.py' \
    "$canceller"
