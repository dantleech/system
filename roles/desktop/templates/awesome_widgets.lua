-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create an ACPI widget                                                        
batterywidget = widget({ type = "textbox" })                                    
batterywidget.text = "| Battery | "                                            
batterywidgettimer = timer({ timeout = 5 })                                     
batterywidgettimer:add_signal("timeout",                                        
    function()                                                                    
        fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))                       
        batterywidget.text = "|" .. fh:read("*l") .. " | "                         
        fh:close()                                                                  
    end                                                                           
)                                                                               
batterywidgettimer:start()

-- Create an ACPI widget                                                        
uptimewidget = widget({ type = "textbox" })
vicious.register(uptimewidget, vicious.widgets.uptime, '$4 $5 $6 | $1d$2h$3m | ', 13)

-- Create an ACPI widget                                                        
ipwidget = widget({ type = "textbox" })                                    
ipwidget.text = " | IP "                                            
ipwidgettimer = timer({ timeout = 9 })
ipwidgettimer:add_signal("timeout",                                        
    function()                                                                    
        fh = assert(io.popen("hostname -I", "r"))                       
        ipwidget.text = fh:read("*l") .. " | "    
        fh:close()                                                                  
    end                                                                           
)                                                                               

ipwidgettimer:start()

memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, '<span color="lightgreen">$2</span> / $3MB | ', 13)

wlannetwidget = widget({ type = "textbox" })
vicious.register(wlannetwidget, vicious.widgets.net, 'wln ▾ ${wlan0 down_kb} ▴ ${wlan0 up_kb} | ', 3)

ethnetwidget = widget({ type = "textbox" })
vicious.register(ethnetwidget, vicious.widgets.net, 'eth ▾ ${eth0 down_kb} ▴ ${eth0 up_kb} | ', 3)

cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, '<span color="lightgreen">$1%</span> | ')

-- Create a systray
mysystray = widget({ type = "systray" })
