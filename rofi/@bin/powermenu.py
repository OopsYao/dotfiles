#!/usr/bin/env python3
import os

options = {
    'sleep': ' Sleep',
    'hibernate-win': '  Hibernate (Win)',
    'reboot': ' Reboot',
    'shutdown': ' Shutdown',
    'hibernate': '  Hibernate',
}

options_stdin = '\n'.join(options.values())
chosen = os.popen(f"echo '{options_stdin}'"
                  f'| rofi -dmenu -i -p "LET\'S"'
                  f' -theme powermenu').read().strip()
if chosen == options['sleep']:
    os.system('systemctl suspend-then-hibernate')
elif chosen == options['hibernate-win']:
    os.system('sudo grub-reboot Windows && systemctl hibernate')
elif chosen == options['hibernate']:
    os.system('systemctl hibernate')
elif chosen == options['reboot']:
    os.system('systemctl reboot')
elif chosen == options['shutdown']:
    os.system('systemctl poweroff')
