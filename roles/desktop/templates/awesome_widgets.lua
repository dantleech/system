wibox = require("wibox")

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create an ACPI widget                                                        
batterywidget = wibox.widget.textbox()                                    
batterywidget:set_text("| Battery | ")
batterywidgettimer = timer({ timeout = 5 })                                     
batterywidgettimer:connect_signal("timeout",                                        
    function()                                                                    
        fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))                       
        batterywidget:set_text("|" .. fh:read("*l") .. " | ")
        fh:close()                                                                  
    end                                                                           
)                                                                               
batterywidgettimer:start()

-- Create an ACPI widget                                                        
uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, '$4 $5 $6 | $1d$2h$3m | ', 13)


-- Create an ACPI widget                                                        
ipwidget = wibox.widget.textbox()                                    
ipwidget:set_text(" | IP ")
ipwidgettimer = timer({ timeout = 9 })
ipwidgettimer:connect_signal("timeout",                                        
    function()                                                                    
        fh = assert(io.popen("hostname -I | cut -d ' ' -f 1", "r"))                       
        ipwidget:set_text(fh:read("*l") .. " | ")
        fh:close()                                                                  
    end                                                                           
)                                                                               

ipwidgettimer:start()

memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, '<span color="lightgreen">$2</span> / $3MB | ', 13)

wlannetwidget = wibox.widget.textbox()
vicious.register(wlannetwidget, vicious.widgets.net, 'wln ▾ ${wlan1 down_kb} ▴ ${wlan1 up_kb} | ', 3)

ethnetwidget = wibox.widget.textbox()
vicious.register(ethnetwidget, vicious.widgets.net, 'eth ▾ ${eth1 down_kb} ▴ ${eth1 up_kb} | ', 3)

cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="lightgreen">$1%</span> | ')

thermalwidget = wibox.widget.textbox()
vicious.register(thermalwidget, vicious.widgets.thermal, '<span color="lightblue">$1°С</span> | ', 11, "thermal_zone0")

volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, '<span color="gold">$2 $1%</span> | ', 2, 'Master')

-- Create a systray
mysystray = wibox.widget.textbox()
