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
            placement = awful.placement.no_offscreen,
        }
    },
    {
        -- Terminal app specially placed
        rule_any = {class = {'Alacritty', 'kitty'}},
        properties = {
            placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }, -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA', -- Firefox addon DownThemAll.
                'pinentry'
            },
            class = {'matplotlib', 'Matplotlib', 'telegram-desktop', 'TelegramDesktop'},
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
        rule = {role = 'browser'},
        properties = {
            screen = 1,
            tag = 'Web 1',
            titlebars_enabled = false,
            placement = awful.placement.centered
        }
    }, {
        rule = {class = 'netease-cloud-music'},
        properties = {
            screen = 1,
            tag = 'Music',
            titlebars_enabled = false,
            floating = false
        }
    }, {
        -- Make plank unfocusable
        rule = {name = 'plank'},
        properties = {below = true, focusable = false}
    }, {
        rule = {class = 'stalonetray'},
        properties = {below = true, focusable = false}
    }, {
        rule = {class = 'mpv'},
        properties = {titlebars_enabled = false, floating = true}
    }, {
        rule_any = {type = {'dialog', 'splash'}},
        properties = {placement = awful.placement.centered}
    }, {
        rule_any = {class = {'Alacritty', 'wemeet'}},
        properties = {titlebars_enabled = false}
    }, {
        -- Picture in picture
        rule = {name = 'Picture in picture'},
        properties = {titlebars_enabled = false, floating = true, ontop = true}
    }
}
