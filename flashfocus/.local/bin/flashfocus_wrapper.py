#!/usr/bin/env python3

import signal
import time
import setproctitle
import subprocess

setproctitle.setproctitle('flashfocus-wrapper')


class Flashfocus:
    def __init__(self):
        self._fork_flashfocus()

    def _fork_flashfocus(self):
        self.p = subprocess.Popen('flashfocus')

    def handler(self, signum, frame):
        self.p.kill()
        self._fork_flashfocus()


ff = Flashfocus()
signal.signal(signal.SIGUSR1, ff.handler)

# Keep alive
while True:
    time.sleep(1)
