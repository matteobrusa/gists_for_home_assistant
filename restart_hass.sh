killall -w hass
nohup /opt/homeassistant/bin/hass 1>/dev/null 2>/dev/null &
ps ax | grep hass
exit
