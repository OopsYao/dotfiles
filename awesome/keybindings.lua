local keybindings = {}
local awful = require('awful')
local gears = require('gears')
local hotkeys_popup = require('awful.hotkeys_popup')

local modkey = 'Mod4'
local view_nonempty = function(step)
    return function()
        local screen = awful.screen.focused()
        local tags = screen.tags
        for i = 1, #tags do
            local target_index = screen.selected_tag.index + i * step
            local t = tags[1 + (target_index - 1) % #tags]
            if #t:clients() > 0 then
                t:view_only()
                break
            end
        end
    end
end

local navi_by_direction = function(direction)
    return function()
        awful.client.focus.bydirection(direction, nil, true)
        if client.focus then client.focus:raise() end
    end
end

local hotkey = function(awful_func)
    return function(t)
        keys = t[1]
        func = t[2]
        meta = t[3]
        return awful_func(
            {table.unpack(keys, 1, #keys - 1)}, keys[#keys], func, meta
        )
    end
end
local button = hotkey(awful.button)

local globalkeys = gears.table.map(function(hotkey)
    local shortcut, operation, meta = table.unpack(hotkey)
    return awful.key({table.unpack(shortcut, 1, #shortcut - 1)}, shortcut[#shortcut], operation, meta)
end, {
    {
        {modkey, 's'},  hotkeys_popup.show_help,
        {description = 'show help', group = 'awesome'},
    },
    {
        {modkey, 'Left'}, view_nonempty(-1),
        {description = 'view previous', group = 'tag'}
    },
    {
        {modkey, 'Right'}, view_nonempty(-1),
        {description = 'view next', group = 'tag'}
    },
    {
        {modkey, 'Escape'}, awful.tag.history.restore,
        {description = 'go back', group = 'tag'},
    },
    {
        {modkey, 'j'}, navi_by_direction('down'),
        {description = 'focus below by direction', group = 'client'}
    },
    {
        {modkey, 'k'}, navi_by_direction('up'),
        {description = 'focus above by direction', group = 'client'}
    },
    {
        {modkey, 'h'}, navi_by_direction('left'),
        {description = 'focus left by direction', group = 'client'}
    },
    {
        {modkey, 'l'}, navi_by_direction('right'),
        {description = 'focus right by direction', group = 'client'}
    },
    {
        {modkey, '`'}, function()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end
        end, {description = 'go back', group = 'client'}
    },
    {
        {modkey, 'Tab'}, function() awful.client.focus.byidx(1) end,
        {description = 'focus next by index', group = 'client'}
    },
    {
        {modkey, 'Shift', 'Tab'}, function() awful.client.focus.byidx(-1) end,
        {description = 'focus previous by index', group = 'client'}
    },
    {
        {modkey, 'u'}, awful.client.urgent.jumpto,
        {description = 'jump to urgent client', group = 'client'}
    },
    {
        {modkey, 'Shift', 'j'},
        function() awful.client.swap.bydirection('down') end,
        {description = 'swap with below client', group = 'client'}
    },
    {
        {modkey, 'Shift', 'k'},
        function() awful.client.swap.bydirection('up') end,
        {description = 'swap with above client', group = 'client'},
    },
    {
        {modkey, 'Shift', 'h'},
        function() awful.client.swap.bydirection('left') end,
        {description = 'swap with left client', group = 'client'},
    },
    {
        {modkey, 'Shift', 'l'},
        function() awful.client.swap.bydirection('right') end,
        {description = 'swap with right client', group = 'client'}
    }, -- Standard program
    {
        {modkey, 'Control', 'r'}, awesome.restart,
        {description = 'reload awesome', group = 'awesome'}
    },
    {
        {modkey, 'Shift', 'Control', 'q'}, awesome.quit,
        {description = 'quit awesome', group = 'awesome'}
    }, -- Layout manipulation
    {
        {modkey, 'Control', 'h'},
        function() awful.tag.incncol(1, nil, true) end,
        {description = 'increase the number of columns', group = 'layout'}
    },
    {
        {modkey, 'Control', 'l'},
        function() awful.tag.incncol(-1, nil, true) end,
        {description = 'decrease the number of columns', group = 'layout'}
    },
    {
        {modkey, 'space'}, function() awful.layout.inc(1) end,
        {description = 'select next', group = 'layout'}
    },
    {
        {modkey, 'Shift', 'space'}, function() awful.layout.inc(-1) end,
        {description = 'select previous', group = 'layout'}
    },
    {
        {modkey, 'Control', 'n'}, function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    'request::activate', 'key.unminimize', {raise = true}
                )
            end
        end, {description = 'restore minimized', group = 'client'}
    },
    {
        {modkey, 'Control', 'Shift', 'n'}, function()
            while (true) do
                local c = awful.client.restore()
                if c then
                    c:emit_signal(
                        'request::activate', 'key.unminimize', {raise = true}
                    )
                else
                    break
                end
            end
        end, {description = 'restore all minimized', group = 'client'}
    }
})
globalkeys = gears.table.join(table.unpack(globalkeys))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    globalkeys = gears.table.join(
        globalkeys, -- View tag only.
        -- The keycode of number n is 9 + n (19 for number 0)
        awful.key(
            {modkey}, '#' .. i + 9, function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then tag:view_only() end
            end, {description = 'view tag #' .. i, group = 'tag'}
        ), -- Toggle tag display.
        awful.key(
            {modkey, 'Control'}, '#' .. i + 9, function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then awful.tag.viewtoggle(tag) end
            end, {description = 'toggle tag #' .. i, group = 'tag'}
        ), -- Move client to tag.
        awful.key(
            {modkey, 'Shift'}, '#' .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end,
            {description = 'move focused client to tag #' .. i, group = 'tag'}
        ), -- Toggle tag on focused client.
        awful.key(
            {modkey, 'Control', 'Shift'}, '#' .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:toggle_tag(tag) end
                end
            end, {
                description = 'toggle focused client on tag #' .. i,
                group = 'tag'
            }
        )
    )
end
root.keys(globalkeys)

-- Client keys and buttons
keybindings.clientkeys = gears.table.join(
    awful.key(
        {modkey}, 'f', function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end, {description = 'toggle fullscreen', group = 'client'}
    ), awful.key(
        {modkey, 'Shift'}, 'c', function(c) c:kill() end,
        {description = 'close', group = 'client'}
    ), awful.key(
        {modkey, 'Control'}, 'space', awful.client.floating.toggle,
        {description = 'toggle floating', group = 'client'}
    ), awful.key(
        {modkey, 'Control'}, 'Return',
        function(c) c:swap(awful.client.getmaster()) end,
        {description = 'move to master', group = 'client'}
    ), awful.key(
        {modkey}, 'o', function(c) c:move_to_screen() end,
        {description = 'move to screen', group = 'client'}
    ), awful.key(
        {modkey}, 't', function(c) c.ontop = not c.ontop end,
        {description = 'toggle keep on top', group = 'client'}
    ), awful.key(
        {modkey}, 'n', function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end, {description = 'minimize', group = 'client'}
    )
)

local helpers = require 'helpers'
keybindings.clientbuttons = gears.table.join(
    awful.button(
        {}, 1, function(c)
            c:emit_signal('request::activate', 'mouse_click', {raise = true})
        end
    ), awful.button(
        {modkey}, 1, function(c)
            c:emit_signal('request::activate', 'mouse_click', {raise = true})
            c:emit_signal('request::move')
            helpers.mouse_move(c)
        end
    ), awful.button(
        {modkey, 'Shift'}, 1, function(c)
            c:emit_signal('request::activate', 'mouse_click', {raise = true})
            helpers.mouse_resize(c)
        end
    ), awful.button(
        {modkey}, 3, function(c)
            c:emit_signal('request::activate', 'mouse_click', {raise = true})
            helpers.mouse_resize(c)
        end
    )
)

return keybindings
