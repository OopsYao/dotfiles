#!/usr/bin/env python3

import yaml
import os
import sys
import between_lines as bl

CONFIG_FILE = '~/.config/mineschemes/config.yml'
CURRENT_THEME = sys.stdin.read().strip()
if CURRENT_THEME not in ['dark', 'light']:
    raise ValueError


with open(os.path.expanduser(CONFIG_FILE), 'r') as f:
    config = yaml.safe_load(f)

    tasks = config['tasks']
    for t in tasks:
        bl.write(t['file'], t[CURRENT_THEME], t.get('comment-mark', '#'))

    hooks = config['hooks']
    for h in hooks:
        if type(h) is dict:
            os.system(h[CURRENT_THEME])
        else:
            os.system(h)
