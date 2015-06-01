-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")
require("vicious")

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
    awesome.add_signal("debug::error", function (err)
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
--awesome.add_signal("focus", function(c)
    --c.border_color = beautiful.border_focus
    --c.opacity = 1
--end)

--awesome.add_signal("unfocus", function(c)
    --c.border_color = beautiful.border_normal
    --c.opacity = 0.7
--end)

require("variables")
require("menu")
require("layout")
require("bindings")
require("rules")
require("autostart")
