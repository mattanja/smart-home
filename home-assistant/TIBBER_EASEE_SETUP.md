# Tibber + Easee Charging Automation Setup Guide

## Scope (meters & contracts)

This stack is **only** for the **company** EV charging path:

| | House (private) | Wallboxes (company) |
|--|-----------------|---------------------|
| Meter | Separate private meter | Dedicated meter for Easee only |
| Contract | **Immergrün** (Eberdingen), from 2025-12-27: **30,67 ct/kWh** + **14,99 €/Monat** Grundpreis | **Tibber** on **kern.services** |
| PV | Both mini-PVs (Shelly + Hoymiles/Solarman) are **private** → house meter | No PV on this meter |

Do **not** use Tibber prices for house loads (dishwasher, Umwälzpumpe, …). Tibber automations = Easee only.

## Prerequisites

✅ HACS installed
✅ hass.tibber_prices integration installed and configured
✅ easee_hass integration installed and configured

## Step 1: Identify Your Sensor Entity IDs

After installing the integrations, you need to identify the actual entity IDs in Home Assistant:

### Tibber Sensors (hass.tibber_prices)

1. Go to **Settings** → **Devices & Services** → **Tibber Price Information & Ratings**
2. Click on **Entities** tab
3. Look for sensors like:
   - `sensor.tibber_tomorrow_hourly_prices` (or similar name)
   - `binary_sensor.tibber_tomorrows_data_available`
   - `sensor.tibber_tomorrow_*` (various price sensors)

**Common sensor names:**
- `sensor.tibber_tomorrow_hourly_prices`
- `sensor.tibber_tomorrow_price_*`
- Check the integration documentation: https://github.com/jpawlowski/hass.tibber_prices

### Easee Sensors and Services

1. Go to **Settings** → **Devices & Services** → **Easee**
2. Click on **Entities** tab
3. Look for:
   - Switch entities for your charger (e.g., `switch.easee_charger_*`)
   - Sensor entities for charging status

**Common entity names:**
- `switch.easee_charger_*` (for starting/stopping)
- `sensor.easee_charger_*` (for status)

4. Go to **Developer Tools** → **Services**
5. Search for "easee" to see available services:
   - `easee.start` or `easee.start_charging`
   - `easee.stop` or `easee.stop_charging`
   - Or the charger might expose a simple `switch.turn_on` / `switch.turn_off`

## Step 2: Update Automation Entity IDs

Edit `/config/automations.yaml` and update the following:

1. **In the calculation automation:**
   - Replace `sensor.tibber_tomorrow_hourly_prices` with your actual sensor name
   - Replace `binary_sensor.tibber_tomorrows_data_available` with your actual sensor name

2. **In the start/stop charging automations:**
   - Replace `switch.easee_charger` with your actual Easee switch entity ID
   - Update the service name (`easee.start`, `easee.stop`, or `switch.turn_on`/`switch.turn_off`)

## Step 3: Verify Price Data Structure

The automation assumes the Tibber sensor provides price data in a specific format. You may need to adjust the template based on your sensor's attributes.

To check the sensor structure:
1. Go to **Developer Tools** → **States**
2. Find your Tibber tomorrow price sensor
3. Check the `state` and `attributes` to see the data structure
4. Adjust the template in the automation accordingly

## Step 4: Test the Automation

1. Manually trigger the calculation automation to test
2. Check the helper entities are populated:
   - `input_datetime.cheapest_charging_window_start`
   - `input_datetime.cheapest_charging_window_end`
   - `input_number.cheapest_charging_window_avg_price`
   - `input_text.cheapest_charging_window_date`

3. Test the start/stop automations manually or wait for the scheduled time

## Troubleshooting

### "Entity not found" errors
- Verify entity IDs match your actual setup
- Check the integration is properly configured
- Restart Home Assistant after installing integrations

### Price calculation not working
- Check if tomorrow's prices are available (sensor should show data after 1pm)
- Verify the price data structure matches the template expectations
- Check Home Assistant logs for template errors

### Easee control not working
- Verify the service name is correct (check Developer Tools → Services)
- Check the entity ID matches your charger
- Ensure the charger is online and accessible

## Alternative: Using hass.tibber_prices Best Price Sensors

If hass.tibber_prices provides sensors that already identify best price intervals, you might be able to simplify the automation by using those sensors directly instead of calculating manually.

Check for sensors like:
- `binary_sensor.tibber_best_price_interval`
- `sensor.tibber_current_interval_price_rating`

These might make the automation simpler!

