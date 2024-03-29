#!/usr/bin/env python3
# https://github.com/florentc/xob#ready-to-use-brightness-bar
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler, FileModifiedEvent
import time

brightness_file = '/sys/class/backlight/intel_backlight/brightness'
max_brightness_file = '/sys/class/backlight/intel_backlight/max_brightness'
with open(max_brightness_file, 'r') as f:
    maxvalue = int(f.read())


def notify(file_path):
    with open(file_path, 'r') as f:
        value = int(int(f.read()) / maxvalue * 100)
        print(value, flush=True)


class Handler(FileSystemEventHandler):

    def on_modified(self, event):
        if isinstance(event, FileModifiedEvent):
            notify(event.src_path)


handler = Handler()
observer = Observer()
observer.schedule(handler, path=brightness_file)
observer.start()
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    observer.stop()
observer.join()
