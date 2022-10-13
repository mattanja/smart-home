# smart-home

Full docker-compose installation of Home-Automation with the following components:

* Home-Assistant (https://www.home-assistant.io/) to view and control all devices
* ioBroker (https://www.iobroker.net/) to automate some additional devices and to broker data from Cloud services into Mosquitto and Home-Assistant
* Mosquitto (https://mosquitto.org/) as MQTT broker
* InfluxDB (https://www.influxdata.com/) to store data
* Telegraf (https://www.influxdata.com/time-series-platform/telegraf/) to collect data into InfluxDB
* Grafana (https://grafana.com/) to visualize data

## Usage

* Clone the repository on a docker host (for example QNAP or Synology NAS systems in hour home)
* Copy the file template.env to .env: `cp template.env .env`
* Start all containers: `docker-compose up -d`
* The initialization of Home-Assistant, ioBroker, InfluxDB and Grafana will require additional manual steps, tbd.

