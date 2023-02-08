local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local xresources = require "beautiful.xresources"

local dpi = xresources.apply_dpi
local modkey = "Mod4"
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

local icons = gears.table.map(function(icon)
  return os.getenv "HOME" .. "/.config/awesome/icons/" .. icon
end, {
  "archlinux.svg",
  "firefox.svg",
  "code.svg",
  "quote.svg",
  "spotify.svg",
  "docker.svg",
  "paragraph.svg",
  "github.svg",
  "chrome.svg",
  "neovim.svg",
})
local update_tags = function(self, tag, init)
  local color = beautiful.fg_normal

  local container_role = self:get_children_by_id("container_role")[1]
  container_role.bg = "#ffffff00" -- Transparent

  if tag.selected then
    container_role.bg = "#2e3440"
    color = "#fff"
  end

  local icon_role = self:get_children_by_id("icon_role")[1]
  local img = icons[tag.index]
  icon_role.image = gears.color.recolor_image(img, color)
  local text_role = self:get_children_by_id("indicator_role")[1]
  local indicator = tag.index
  if indicator == 10 then
    indicator = 0
  end
  text_role.markup = '<span color="' .. color .. '">' .. indicator .. "</span>"
end

return function(params)
  local screen = params.screen
  local taglist = awful.widget.taglist {
    filter = awful.widget.taglist.filter.noempty,
    screen = screen,
    buttons = taglist_buttons,
    widget_template = {
      id = "container_role",
      widget = wibox.container.background,
      shape = gears.shape.circle,
      {
        widget = wibox.container.margin,
        top = dpi(5),
        bottom = dpi(5),
        left = dpi(3.1),
        right = dpi(3.1),
        {
          layout = wibox.layout.align.horizontal,
          { id = "icon_role", widget = wibox.widget.imagebox },
          {
            id = "indicator_role",
            widget = wibox.widget.textbox,
            valign = "bottom",
            font = "DejaVu Sans 5",
          },
        },
      },
      create_callback = function(self, tag, index, tags)
        update_tags(self, tag)
      end,
      update_callback = function(self, tag, index, tags)
        update_tags(self, tag)
      end,
    },
  }
  return taglist
end
