scp config/configuration.yaml  homeassistant@192.168.1.95:.homeassistant/
ssh -f  homeassistant@192.168.1.95 ./restart_hass.sh
