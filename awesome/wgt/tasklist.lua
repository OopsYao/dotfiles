local awful = require 'awful'
local wibox = require 'wibox'
local xresources = require 'beautiful.xresources'

local dpi = xresources.apply_dpi

return function()
    return awful.widget.tasklist {
        screen = awful.screen.focused(),
        filter = awful.widget.tasklist.filter.currenttags,
        layout = {spacing = dpi(5), layout = wibox.layout.fixed.horizontal},
        widget_template = {id = 'icon_role', widget = wibox.widget.imagebox}
    }
end
