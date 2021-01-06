## These snippets help you visualise information from the an ETA furnace equipped with the ETA touch software. 
The furnace exposes a RESTful API at the port 8080 which can be used to fetch information and also control (turn on and off) the furnace.

Let's start with some useful sensors.
Don't forget to activate the API access to the furnace.
```python
sensor:
  - platform: rest
    name: ETA temp
    resource: http://192.168.1.98:8080/user/var/120/10241/0/0/12197
    value_template: '{{ value_json.eta.value["#text"] | float /10 }}'
    unit_of_measurement: °C
    scan_interval: 300
    
  - platform: rest
    name: ETA storage
    resource: http://192.168.1.98:8080/user/var/40/10201/0/0/12015
    value_template: '{{ value_json.eta.value["#text"] | float /10 }}'
    unit_of_measurement: KG
    scan_interval: 3600
    
  - platform: rest
    name: ETA buffer
    resource: http://192.168.1.98:8080/user/var/120/10601/0/0/12528
    value_template: '{{ value_json.eta.value["#text"] | float /10 }}'
    unit_of_measurement: "%"
    scan_interval: 300
    device_class: battery
    
  - platform: rest
    name: ETA consumption since maintenance
    resource: http://192.168.1.98:8080/user/var/40/10021/0/0/12014
    value_template: '{{ value_json.eta.value["#text"] | float /10 }}'
    unit_of_measurement: KG
    scan_interval: 3600
    
  - platform: rest
    name: ETA total consumption
    resource: http://192.168.1.98:8080/user/var/40/10021/0/0/12016
    value_template: '{{ value_json.eta.value["#text"] | float /10 }}'
    unit_of_measurement: KG
    scan_interval: 3600

  - platform: rest
    name: ETA furnace status
    resource: http://192.168.1.98:8080/user/var/40/10021/0/0/19402
    value_template: '{{value_json.eta.value["@strValue"]}}'
```

Here's a switch to control the heater's water pump. Handle with care.
```python
switch:
  - platform: command_line
    switches:
      eta_pump:
        command_on: 'curl -d "value=1803" -X POST 192.168.1.98:8080/user/var/120/10101/0/0/12080'
        command_off: 'curl -d "value=1802" -X POST 192.168.1.98:8080/user/var/120/10101/0/0/12080'
        command_state: 'curl -s 192.168.1.98:8080/user/var/120/10101/0/0/12080 | grep  -c "1803"'
        value_template: '{{ value | int == 1 }}' 
```
