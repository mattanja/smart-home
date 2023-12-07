#!/bin/bash

#;  "src": "shellyplusplugs-64b7080d0908",
#;  "dst": "shellies/shelly-steckdose-01/events",
export MQTT_SERVER="corenetstorage"
export MQTT_PORT="1883"
export SHELLY_ID="shellies/shelly-steckdose-01" # The <shelly-id> of your device
export MQTT_USER="mattanja"
export MQTT_PASSWORD=""


## Tut nicht, weiß nicht warum

echo mosquitto_pub -h ${MQTT_SERVER} -p ${MQTT_PORT} -u ${MQTT_USER} -P ${MQTT_PASSWORD} -t "${SHELLY_ID}/command/switch:0" -m toggle

