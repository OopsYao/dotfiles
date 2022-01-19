#!/usr/bin/env python3
import os


def screenshot():
    shot_dir = "~/Pictures/screenshots"
    cmd_clipboard = (
        "xclip -selection clipboard -t image/png"
        f" -i {shot_dir}/`ls -1 -t {shot_dir} | head -1`"
    )
    return {
        "Screenshot": f"maim -suDB {shot_dir}/screenshot_$(date +%Y%m%d_%H%M%S).png"
        f" && {cmd_clipboard}",
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
