local awful = require 'awful'
local xresources = require 'beautiful.xresources'
local wibox = require 'wibox'
local gears = require 'gears'
local tags = require 'tags'

local dpi = xresources.apply_dpi
awful.screen.connect_for_each_screen(
    function(s)
        local selected = true -- Set the first tag as selected
        for k, v in pairs(tags) do
            awful.tag
                .add(v[1], {layout = v[2], screen = s, master_count = 3, selected = selected, column_count = 1})
            selected = false
        end

        awful.screen.padding(
            screen[s],
            {top = dpi(15), left = dpi(15), right = dpi(15), bottom = dpi(25)}
        )
    end
)

-- Signal function to execute when a new client appears.
client.connect_signal(
    'manage', function(c)
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        if not awesome.startup then awful.client.setslave(c) end

        if awesome.startup and not c.size_hints.user_position and
            not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    'mouse::enter', function(c)
        c:emit_signal('request::activate', 'mouse_enter', {raise = false})
    end
)

-- On startup
awesome.connect_signal(
    'startup', function(args)
        awful.util.spawn('systemctl --user start xsession.target')
        awful.util.spawn('dex -a -e awesome')
    end
)

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal(
        'debug::error', function(err)
            -- Make sure we don't go into an endless error loop
            if in_error then return end
            in_error = true

            naughty.notify(
                {
                    preset = naughty.config.presets.critical,
                    title = 'Oops, an error happened!',
                    text = tostring(err)
                }
            )
            in_error = false
        end
    )
end

local helpers = require 'helpers'
client.connect_signal(
    'request::titlebars', function(c)
        -- Drag and resize clients
        local buttons = gears.table.join(
            awful.button(
                {}, 1, function()
                    c:emit_signal(
                        'request::activate', 'titlebar', {raise = true}
                    )
                    helpers.mouse_move(c)
                end
            ), awful.button(
                {}, 3, function()
                    c:emit_signal(
                        'request::activate', 'titlebar', {raise = true}
                    )
                    helpers.mouse_resize(c)
                end
            )
        )

        awful.titlebar(c):setup{
            {
                {
                    awful.titlebar.widget.minimizebutton(c),
                    awful.titlebar.widget.maximizedbutton(c),
                    awful.titlebar.widget.closebutton(c),
                    layout = wibox.layout.fixed.horizontal()
                },
                margins = 5,
                widget = wibox.container.margin
            },
            {
                {
                    widget = awful.titlebar.widget.titlewidget(c),
                    align = 'center'
                },
                buttons = buttons,
                layout = wibox.layout.flex.horizontal
            },
            nil,
            layout = wibox.layout.align.horizontal
        }
    end
)
