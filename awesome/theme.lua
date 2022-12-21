-- Default file: https://awesomewm.org/apidoc/sample%20files/theme.lua.html
local gears = require('gears')

-- Define the image to load
my_theme = gears.filesystem.get_configuration_dir() .. '/icons/'
local theme = {}
local xresources = require('beautiful.xresources')
local dpi = xresources.apply_dpi

theme.useless_gap = dpi(4)
theme.master_width_factor = 0.75

theme.bg_normal = '#eeeeee'
theme.bg_focus = '#2c3e67'

theme.fg_normal = '#000000'
theme.fg_focus = '#000000'

theme.wibar_bg = '#efefef85'
theme.wibar_icon = my_theme .. 'archlinux.svg'
theme.wibar_icon_color = '#b48ead'
theme.bg_systray = '#24283B'

theme.tag_focus = '#b48ead'

theme.systray_icon_spacing = dpi(3)

theme.tasklist_font = 'Noto Sans CJK SC Regular 8'
theme.tasklist_fg_focus = '#000000'
theme.tasklist_plain_task_name = true

theme.titlebar_bg = '#ffffffaa'

theme.titlebar_close_button_normal = my_theme .. 'inactive.png'
theme.titlebar_close_button_focus = my_theme .. 'close.png'
theme.titlebar_close_button_focus_hover = my_theme .. 'close_hover.png'

theme.titlebar_minimize_button_normal = my_theme .. 'inactive.png'
theme.titlebar_minimize_button_focus = my_theme .. 'minimize.png'
theme.titlebar_minimize_button_focus_hover = my_theme .. 'minimize_hover.png'

theme.titlebar_maximized_button_normal_inactive = my_theme .. 'inactive.png'
theme.titlebar_maximized_button_normal_active = my_theme .. 'inactive.png'
theme.titlebar_maximized_button_focus_inactive = my_theme .. 'floating.png'
theme.titlebar_maximized_button_focus_inactive_hover = my_theme ..
                                                           'floating_hover.png'
theme.titlebar_maximized_button_focus_active = my_theme .. 'floating.png'
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme
