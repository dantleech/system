-- Standard awesome library
awful = require("awful")
require("awful.autofocus")
require("awful.rules")
gears = require("gears")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")

-- Load Debian menu entries
require("debian.menu")
vicious = require("vicious")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

--transparency
--awesome.connect_signal("focus", function(c)
    --c.border_color = beautiful.border_focus
    --c.opacity = 1
--end)

--awesome.connect_signal("unfocus", function(c)
    --c.border_color = beautiful.border_normal
    --c.opacity = 0.7
--end)

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

require("variables")

-- Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

require("menu")
require("layout")
require("bindings")
require("rules")

require("autostart")
