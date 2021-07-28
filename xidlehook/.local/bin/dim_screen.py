#!/usr/bin/env python3
import os
import sys
from easing_functions import CubicEaseInOut

start = 1
end = 0.2
steps = 16
# ease maps [0, steps] to [start, end]
ease = CubicEaseInOut(start, end, steps)
dim_seq = [ease(t) for t in range(1 + steps)]
brig_seq = reversed(dim_seq)


def adjust(br_seq):
    for b in br_seq:
        os.system(f'xrandr --output "$PRIMARY_DISPLAY" --brightness {b:.2f}')


if len(sys.argv) > 1 and sys.argv[1] == 'brighten':
    adjust(brig_seq)
else:
    adjust(dim_seq)
