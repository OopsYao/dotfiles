#!/usr/bin/env python

import yaml
import os
import sys
import re

CONFIG_FILE = '~/.config/mineschemes/config.yml'
CURRENT_THEME = sys.stdin.read().strip()
if CURRENT_THEME not in ['dark', 'light']:
    raise ValueError


def inject_file(file_path, content, comment_mark):
    IDENTIFIER_START = "START OOO"
    IDENTIFIER_END = "END OOO"

    with open(os.path.expanduser(file_path), 'r+') as f:
        origin_content = f.read()
        leading = f'{comment_mark} {IDENTIFIER_START}'
        ending = f'{comment_mark} {IDENTIFIER_END}'
        m = re.sub(rf'^{leading}$.*^{ending}$',
                   '\n'.join([leading, content, ending]),
                   origin_content,
                   flags=re.MULTILINE | re.DOTALL)
        f.seek(0)  # Move back the pointer
        f.write(m)
        f.truncate()  # Truncate the left (original) content in the file


with open(os.path.expanduser(CONFIG_FILE), 'r') as f:
    config = yaml.safe_load(f)

    tasks = config['tasks']
    for t in tasks:
        inject_file(t['file'], t[CURRENT_THEME], t.get('comment-mark', '#'))

    hooks = config['hooks']
    for h in hooks:
        if type(h) is dict:
            os.system(h[CURRENT_THEME])
        else:
            os.system(h)
