-- Tag config
local awful = require "awful"

-- Set available layouts
local l = awful.layout.suit
awful.layout.layouts = { l.tile.bottom }

return {
  { "Misc 1", l.tile.bottom },
  { "Web 1", l.tile.bottom },
  { "Code 1", l.tile.bottom },
  { "Read 1", l.tile.bottom },
  { "Music", l.tile.bottom },
  { "Home", l.tile.bottom },
  { "Read 2", l.tile.bottom },
  { "Code 2", l.tile.bottom },
  { "Web 2", l.tile.bottom },
  { "Misc 2", l.tile.bottom },
}
