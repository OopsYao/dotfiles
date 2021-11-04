#!/usr/bin/env python3
import os
import sys
from easing_functions import CubicEaseInOut


def unique(arr):
    uni = []
    s = set()
    for it in arr:
        if it not in s:
            uni.append(it)
            s.add(it)
    return uni


start = 1
end = 0.35
steps = 32
# ease maps [0, steps] to [start, end]
ease = CubicEaseInOut(start, end, steps)
dim_seq = unique([f'{ease(t):.2f}'
                  for t in range(1 + steps)])  # xrandr allows two-digits
brig_seq = [*reversed(dim_seq)]


# Displays like ['HDMI-1', 'eDP-1']
displays = [d for d
            in os.popen("xrandr | awk '/ connected/{print $1}'").read()
            .split('\n')
            if d != '']


def adjust(br_seq):
    for b in br_seq[1:]:  # Skip the start value
        for d in displays:
            os.system(f'xrandr --output "{d}" --brightness {b}')


if len(sys.argv) > 1 and sys.argv[1] == 'brighten':
    adjust(brig_seq)
else:
    adjust(dim_seq)
