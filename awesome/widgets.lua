local awful = require "awful"
local beautiful = require "beautiful"
local wibox = require "wibox"
local gears = require "gears"
local xresources = require "beautiful.xresources"

local dpi = xresources.apply_dpi

awful.screen.connect_for_each_screen(function(s)
  awful.wibar({ position = "top", screen = s }):setup {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    {
      widget = wibox.container.margin,
      margins = dpi(3),
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(3),
        {
          widget = wibox.widget.imagebox,
          image = gears.color.recolor_image(beautiful.wibar_icon, beautiful.wibar_icon_color),
        },
        require "wgt.xwindow" {},
      },
    },
    {
      widget = wibox.container.margin,
      margins = dpi(2.1),
      require "wgt.workspace" { screen = s },
    },
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(3),
      {
        widget = wibox.container.margin,
        top = dpi(3),
        bottom = dpi(3),
        {
          layout = wibox.layout.fixed.horizontal,
          spacing = dpi(8),
          require "wgt.player" {},
          require "wgt.clientnum" {},
          -- require 'awesome-wm-widgets.github-activity-widget.github-activity-widget' {
          --     username = 'OopsYao'
          -- },
          require "battery-widget" {
            ac_prefix = " ",
            battery_prefix = " ",
            widget_font = "Ubuntu Mono 9",
          },
          -- require 'net_widgets'.wireless {interface = 'wlan0'},
          wibox.widget.textclock "%m月%d日 %l:%M %p",
        },
      },
      -- Systray
      {
        widget = wibox.container.background,
        shape = gears.shape.rectangular_tag,
        bg = beautiful.bg_systray,
        {
          widget = wibox.container.margin,
          left = dpi(10),
          top = dpi(2.5),
          bottom = dpi(2.5),
          wibox.widget.systray {},
        },
      },
    },
  }
end)
