local mod = {}
local awful = require('awful')

local function unmaximize(c)
    local geo = c:geometry()
    c.maximized = false
    c:geometry(geo)
end

function mod.mouse_move(c)
    unmaximize(c)
    awful.mouse.client.move(c)
end

function mod.mouse_resize(c)
    unmaximize(c)
    awful.mouse.client.resize(c)
end

return mod
