#!/usr/bin/env python3
import os
import sys
from easing_functions import CubicEaseInOut
import time

start = 1
end = 0.35
steps = 16
# ease maps [0, steps] to [start, end]
ease = CubicEaseInOut(start, end, steps)
dim_seq = [ease(t) for t in range(1 + steps)]
brig_seq = reversed(dim_seq)


# Displays like ['HDMI-1', 'eDP-1']
displays = [d for d
            in os.popen("xrandr | awk '/ connected/{print $1}'").read()
            .split('\n')
            if d != '']


def adjust(br_seq):
    for b in br_seq:
        for d in displays:
            os.system(f'xrandr --output "{d}" --brightness {b:.2f}')
        time.sleep(0.01)


if len(sys.argv) > 1 and sys.argv[1] == 'brighten':
    adjust(brig_seq)
else:
    adjust(dim_seq)
