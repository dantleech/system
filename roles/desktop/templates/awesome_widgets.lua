-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create an ACPI widget                                                        
batterywidget = widget({ type = "textbox" })                                    
batterywidget.text = " | Battery | "                                            
batterywidgettimer = timer({ timeout = 5 })                                     
batterywidgettimer:add_signal("timeout",                                        
  function()                                                                    
      fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))                       
      batterywidget.text = " |" .. fh:read("*l") .. " | "                         
      fh:close()                                                                  
    end                                                                           
)                                                                               
batterywidgettimer:start()

-- Create a systray
mysystray = widget({ type = "systray" })

