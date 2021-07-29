#!/usr/bin/env python3
import os

options = {
    'sleep': ' Sleep',
    'hibernate': '  Hibernate',
    'reboot': ' Reboot',
    'shutdown': ' Shutdown'
}

options_stdin = '\n'.join(options.values())
rofi_style = '~/.config/rofi/styles/powermenu.rasi'
chosen = os.popen(f"echo '{options_stdin}'"
                  f'| rofi -dmenu -i -p "LET\'S"'
                  f' -theme {rofi_style}').read().strip()
if chosen == options['sleep']:
    os.system('systemctl suspend')
elif chosen == options['hibernate']:
    os.system('systemctl hibernate')
elif chosen == options['reboot']:
    os.system('systemctl reboot')
elif chosen == options['shutdown']:
    os.system('systemctl poweroff')
