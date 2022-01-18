#!/usr/bin/env python3
import os


def screenshot():
    shot_dir = "~/Pictures/screenshots"
    filename = f"{shot_dir}/screenshot_%Y%m%d_%H%M%S.png"

    cmd_clipboard = (
        "xclip -selection clipboard -t image/png"
        f" -i {shot_dir}/`ls -1 -t {shot_dir} | head -1`"
    )
    return {
        "Screenshot (rectangle)": f"scrot -s {filename} && {cmd_clipboard}",
        "Screenshot (full)": f"scrot -d 1 {filename} && {cmd_clipboard}",
    }


options = {
    "Color pick": "xcolor -s | xclip -selection clipboard",
    **screenshot(),
}
options_stdin = "\n".join(options.keys())
cmd_key = (
    os.popen(f"echo '{options_stdin}' | rofi -dmenu -i -p \"LET'\"S").read().strip()
)

if cmd_key in options.keys():
    os.system(options[cmd_key])
