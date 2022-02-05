-- Default file: https://awesomewm.org/apidoc/sample%20files/rc.lua.html
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local gears = require('gears')
require('awful.autofocus')
-- Theme handling library
local beautiful = require('beautiful')
-- Notification library
local naughty = require('naughty')

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors
    })
end

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. 'theme.lua')

require 'hooks'
require 'rules'
require 'widgets'
require 'keybindings'
