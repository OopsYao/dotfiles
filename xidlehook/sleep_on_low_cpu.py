#!/usr/bin/env python3
import psutil
import os

threshold = 22


def cpu_usage():
    while True:
        # CPU usage in x sec, this step is blocking
        yield psutil.cpu_percent(30)


for p in cpu_usage():
    if p < threshold:
        break
os.system('systemctl suspend')
