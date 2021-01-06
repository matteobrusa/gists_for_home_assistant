## Daily consumption
The daily consumption data is created with a query executed daily.

The query takes the data from a monotonic increasing sensor (fuel consumption in my case) and synthethizes a daily consumption metric to be visualised in the HA dashboard.

We need first a fake sensor, here's one.

```python
input_number:
  fake:
    name: fake
    min: 0
    max: 30
    step: 1
    mode: box   

sensor:
  - platform: template
    sensors:
      synth:
        value_template: >
          {{ states('input_number.fake') }} 
```

The insert query from the daily_consumption.sql file can be then visualised with a history graph or the fine mini graph card.


