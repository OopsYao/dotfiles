-- A widget to monitor (minimized/total) client numbers
local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')

-- Counter class
local counter = function()
    local c = 0
    local ctr = {}
    function ctr:inc()
        c = c + 1
        return
    end
    function ctr:value() return c end
    return ctr
end

-- Get minimized and all client numbers in current tag
local get_clients_number = function()
    local t = awful.screen.focused().selected_tag
    local screen = awful.screen.focused()
    local tag = screen.selected_tag
    local clients = tag:clients()
    local counter_minimized = counter {}
    for _, client in pairs(clients) do
        if client.minimized then counter_minimized.inc() end
    end
    return {all = #clients, minimized = counter_minimized.value()}
end

-- Widget button for restoring one or all clients (of current tag)
local restore = function(single)
    return function()
        while (true) do
            local c = awful.client.restore()
            if c then
                c:emit_signal(
                    'request::activate', 'key.unminimize', {raise = true}
                )
                if single then break end
            else
                break
            end
        end
    end
end

return function()
    local clientnum = wibox.widget {
        widget = wibox.widget.textbox,
        -- Left click to restore and right click to restore all
        buttons = gears.table.join(
            awful.button({}, 1, restore(true)), awful.button({}, 3, restore())
        ),
        font = 'Ubuntu Mono 9',
    }
    local update = function()
        local num = get_clients_number()
        if num.minimized == 0 then
            clientnum.text = ''
        else
            clientnum.text = ' ' .. num.minimized
        end
    end

    -- Update on signals
    -- ref: https://github.com/awesomeWM/awesome/blob/7a759432d3100ff6870e0b2b427e3352bf17c7cc/lib/awful/widget/tasklist.lua#L641-L676
    for _, s in pairs {
        'tagged', 'untagged', 'manage', 'unmanage', 'property::minimized'
    } do client.connect_signal(s, update) end
    awful.tag.attached_connect_signal(
        awful.screen.focused(), 'property::selected', update
    )

    return clientnum
end
