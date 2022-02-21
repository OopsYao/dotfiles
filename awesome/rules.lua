local awful = require('awful')
local keybindings = require('keybindings')

awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            keys = keybindings.clientkeys,
            buttons = keybindings.clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_overlap +
                awful.placement.no_offscreen
        }
    }, -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA', -- Firefox addon DownThemAll.
                'pinentry'
            },
            class = {'matplotlib', 'Matplotlib'},
            role = {
                'pop-up' -- Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    }, -- Add titlebars to normal clients and dialogs
    {
        rule_any = {type = {'normal', 'dialog'}},
        properties = {titlebars_enabled = true}
    }, -- Set Firefox to always map on the tag named "2" on screen 1.
    {
        rule = {class = 'firefox', type = 'normal'},
        properties = {
            screen = 1,
            tag = 'Web 1',
            maximized_horizontal = true,
            maximized_vertical = true,
            titlebars_enabled = false
        }
    }, {
        rule = {class = 'netease-cloud-music'},
        properties = {
            screen = 1,
            tag = 'Music',
            titlebars_enabled = false,
            floating = false
        }
    }, -- Set Zathura to always map on the Reading tag
    {rule = {class = 'Zathura'}, properties = {tag = 'Read 1'}},
    -- Make plank unfocusable
    {rule = {name = 'plank'}, properties = {below = true, focusable = false}},
    {
        rule = {class = 'stalonetray'},
        properties = {below = true, focusable = false}
    }, {
        rule = {class = 'mpv'},
        properties = {titlebars_enabled = false, floating = true}
    }
}
