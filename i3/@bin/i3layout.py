#!/usr/bin/env python3

import os
import sys
from i3ipc import Connection, Event
import setproctitle

sys.path.append(os.path.expanduser('~/.config/i3'))
from layout_rules import rules  # NOQA

setproctitle.setproctitle('my-i3layout')
i3 = Connection()


def get_focused_workspace():
    return i3.get_tree().find_focused().workspace()


def expand(**gaps):
    '''Expand outer, horizontal, vertical to left and right'''
    outer = {}
    if 'outer' in gaps:
        v = gaps['outer']
        outer = {
            'left': v,
            'right': v,
            'top': v,
            'bottom': v
        }
    horizontal = {}
    if 'horizontal' in gaps:
        v = gaps['horizontal']
        horizontal = {
            'left': v,
            'right': v
        }
    vertical = {}
    if 'vertical' in gaps:
        v = gaps['vertical']
        vertical = {
            'top': v,
            'bottom': v
        }
    gaps = {**outer, **horizontal, **vertical, **gaps}
    # Delete keys (`outer`, `horizontal`, `vertical`)
    for k in ['outer', 'horizontal', 'vertical']:
        gaps.pop(k, None)
    return gaps


def on_window_num_change(ws):
    '''Listener on tiled windows number of any workspace changed

        ws --- the corresponding workspace of this event
    '''
    # Remember current focused workspace
    focused = get_focused_workspace().name
    # Checkout workspace $ws
    i3.command(f'workspace {ws}')
    # Set gaps on current ws
    action_on_ws()
    # Back and forth
    i3.command(f'workspace {focused}')


def action_on_ws():
    '''Action on current workspace'''
    focused = get_focused_workspace()
    wins = [c.window_class for c in focused
            if c.name is not None and 'off' in c.floating]
    gaps = rules(wins)
    if gaps is None:
        # Default
        set_gaps(outer=4, top=25)
    else:
        set_gaps(**gaps)


def set_gaps(**gaps):
    gaps = expand(**gaps)
    for k, v in gaps.items():
        i3.command(f'gaps {k} current set {v}')


def get_window_nums():
    '''Get current windows numbers of all workspaces'''
    ws_num = {}
    for ws in i3.get_tree().workspaces():
        ws_num.update({ws.name: get_workspace_window_num(ws)})
    return ws_num


def get_workspace_window_num(workspace):
    '''Count the number of windows on a specific workspace'''
    wins = [c.window_class for c in workspace
            if c.name is not None and 'off' in c.floating]
    return len(wins)


def diff_state(state_a, state_b):
    '''Compare two window num dict, return the changed workspaces'''
    workspaces = set((*state_a.keys(), *state_b.keys()))
    changed = []
    for w in workspaces:
        if state_a.get(w, 0) != state_b.get(w, 0):
            changed.append(w)
    return changed


# Store current window numbers of all workspaces
global_state = get_window_nums()


def on_window_change(i3, event):
    ws = i3.get_tree().find_by_id(event.container.id).workspace()
    global global_state
    global_state.update({ws.name: get_workspace_window_num(ws)})
    on_window_num_change(ws.name)


def on_window_move(i3, event):
    current_state = get_window_nums()
    global global_state
    changed = diff_state(global_state, current_state)
    global_state = current_state
    for ws in changed:
        on_window_num_change(ws)


i3.on(Event.WINDOW_NEW, on_window_change)
i3.on(Event.WINDOW_FLOATING, on_window_change)
i3.on(Event.WINDOW_MOVE, on_window_move)
i3.on(Event.WINDOW_CLOSE, on_window_move)
i3.main()
