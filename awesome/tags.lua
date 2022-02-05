-- Tag config
local awful = require 'awful'

-- Set available layouts
local l = awful.layout.suit
awful.layout.layouts = {l.floating, l.fair, l.corner.nw}

return {
    {'Misc 1', l.floating}, {'Web 1', l.floating}, {'Code 1', l.corner.nw},
    {'Read 1', l.fair}, {'Music', l.floating}, {'Home', l.floating},
    {'Read 2', l.fair}, {'Code 2', l.corner.nw}, {'Web 2', l.floating},
    {'Misc 2', l.floating}
}
