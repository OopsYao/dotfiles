local awful = require 'awful'
local wibox = require 'wibox'

return function()
    return awful.widget.tasklist {
        screen = awful.screen.focused(),
        filter = awful.widget.tasklist.filter.focused,
        widget_template = {id = 'text_role', widget = wibox.widget.textbox}
    }
end
