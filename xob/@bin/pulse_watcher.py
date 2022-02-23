#!/usr/bin/env python3
import fileinput
import subprocess


def exec(*cmd):
    """Execute a command and return the output"""
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, _ = p.communicate()
    return out.decode("utf-8").strip()


class State:
    """A container that holds the last state"""

    def __init__(self):
        self.vol = None
        self.output = None

    def update(self, vol, output):
        """If the value is different, update the state and return True"""
        changed = self.vol != vol or self.output != output
        self.vol = vol
        self.output = output
        return changed


state = State()

# Read from stdin on pulseaudio events
for line in fileinput.input():
    # When the volume changes. Note that there are some other events
    # that also can trigger this.
    if "change" in line and "sink" in line:
        vol = (
            exec("pactl", "get-sink-volume", "@DEFAULT_SINK@")
            .split("/")[1]
            .strip()[:-1]
        )

        # If it is muted, append `!`
        mute = exec("pactl", "get-sink-mute", "@DEFAULT_SINK@")
        if "yes" in mute:
            vol = vol + "!"

        # Output
        output = exec("pactl", "get-default-sink")
        if state.update(vol, output):
            print(vol, flush=True)
