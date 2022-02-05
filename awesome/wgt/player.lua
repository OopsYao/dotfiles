-- Music player control based on PlayerCTL
-- https://github.com/altdesktop/playerctl
local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local xresources = require('beautiful.xresources')
local base = require('wibox.widget.base')

local sep = '\t'
local playerctl_format = table.concat(
    {'{{artist}}', '{{title}}', '{{mpris:artUrl}}'}, sep
)
local parse_playerctl_output = function(output)
    output = gears.string.split(output, sep)
    artist = output[1]
    title = output[2]
    cover = output[3]
    return {artist = artist, title = title, cover = cover}
end

local toggle = function() awful.spawn.easy_async('playerctl play-pause') end

return function()
    -- Widget definition
    local player = wibox.widget {
        layout = wibox.layout.fixed.horizontal,
        spacing = xresources.apply_dpi(4),
        {
            -- Don't know why the image is not displayed after setting imagebox clip,
            -- use background container clip as a workground.
            widget = wibox.container.background,
            shape = gears.shape.circle,
            shape_clip = true,
            {id = 'cover', widget = wibox.widget.imagebox}
        },
        {
            id = 'info',
            widget = wibox.widget.textbox,
            buttons = gears.table.join(awful.button({}, 1, toggle)),
        }
    }

    -- Listen on music change
    awful.spawn.with_line_callback(
        'playerctl metadata -F --format "' .. playerctl_format .. '"', {
            stdout = function(line)
                if line ~= '' then
                    local info = parse_playerctl_output(line)
                    player:get_children_by_id('info')[1].text = info.title ..
                                                                    ' - ' ..
                                                                    info.artist
                    player:get_children_by_id('cover')[1].image = string.sub(
                        info.cover, 8
                    )
                end
            end
        }
    )

    -- Listen on player status
    awful.spawn.with_line_callback(
        'playerctl status -F', {
            stdout = function(line)
                if line == '' then
                    -- Player exits
                    player.visible = false
                elseif line == 'Playing' then
                    -- Player starts playing
                    player.visible = true
                elseif line == 'Paused' or line == 'Stopped' then
                    -- Player stops playing
                    player.visible = true
                end
            end
        }
    )
    return player
end
