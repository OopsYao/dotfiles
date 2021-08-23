#!/usr/bin/env python3

import os
import sys
import yaml
import between_lines as bl

if len(sys.argv) <= 1:
    exit(-1)
scheme = sys.argv[1]


def get_entry(config, entry):
    v = config.get(entry)
    if (type(v) == dict):
        return v.get(scheme)
    else:
        return v


class ConfigError(Exception):
    pass

with open(os.path.expanduser('~/.config/gtk/config.yml'), 'r') as f:
    config = yaml.safe_load(f)

    theme = get_entry(config, 'theme')
    icon = get_entry(config, 'icon')
    cursor = get_entry(config, 'cursor')
    if None in [theme, icon, cursor]:
        raise ConfigError('Invalid configuration')


# GTK 2/3
def gtk():
    content = '\n'.join([
        f'gtk-theme-name="{theme}"',
        f'gtk-icon-theme-name="{icon}"',
        f'gtk-cursor-theme-name="{cursor}"',
    ])
    bl.write('~/.config/gtk-3.0/settings.ini', content, '#')
    bl.write('~/.gtkrc-2.0', content, '#')



# XSETTINGSD
def xsettingsd():
    content = '\n'.join([
        f'Net/ThemeName "{theme}"',
        f'Net/IconThemeName "{icon}"',
        f'Gtk/CursorThemeName "{cursor}"',
    ])
    bl.write('~/.xsettingsd', content, '#')
    os.system('killall -HUP xsettingsd')


# GSETTINGS
def gsettings():
    # TODO check if gsettings command available
    gnome_schema = 'org.gnome.desktop.interface'
    for k, v in [
        ('gtk-theme', theme),
        ('icon-theme', icon),
        ('cursor-theme', cursor)
    ]:
        os.system(f'gsettings set {gnome_schema} {k} {v}')


# CURSOR
def cursor_special():
    content = f'Inherits={cursor}'
    bl.write('~/.icons/default/index.theme', content, '#')


gtk()
xsettingsd()
gsettings()
cursor_special()
