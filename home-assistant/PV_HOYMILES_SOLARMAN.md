# PV: Hoymiles + Solarman

## Status (2026-10-09)

| System | Host | Integration | Status |
|--------|------|-------------|--------|
| **Hoymiles** (WiFi DTU / HMS) | `192.168.57.104` (`espressif`) port **10081** | HACS custom [`hoymiles_wifi`](https://github.com/suaveolent/ha-hoymiles-wifi) | **Live** — AC/DC power, per-port Wh totals |
| **Solarman** WiFi module | DHCP often `192.168.57.89` — MAC **`28:9C:6E:82:E0:FE`** | HACS custom [`solarman`](https://github.com/davidrapan/ha-solarman) | Configured @ `.89:8899`; **host was offline** when last checked (stale ARP) — retry when module is up |

**Not Solarman:** Fritz host `Dongle-M-94C8` (`192.168.57.36`, MAC `1C:69:20:7F:94:C8`) is the **Zigbee** dongle — ignore for PV.

Shelly **PV Mini Power Meter** remains an independent meter already used in the Energy dashboard.

## Install (already on live `/config`)

Components under `custom_components/` (gitignored, like other HACS installs):

- `hoymiles_wifi` ← [suaveolent/ha-hoymiles-wifi](https://github.com/suaveolent/ha-hoymiles-wifi)
- `solarman` ← [davidrapan/ha-solarman](https://github.com/davidrapan/ha-solarman)

For updates: add both as HACS **custom repositories** (category Integration), then update via HACS.

## Hoymiles — useful entities

- Power: `sensor.inverter_ac_power`
- Energy (Energy dashboard): per-port `sensor.inverter_port_N_dc_total_energy` (Wh, `total_increasing`)
- Nightly power is often `0`; totals still accumulate

Config entry host: `192.168.57.104`, update interval **35 s** (keep ≥ ~32 s so S-Miles cloud keeps working).

## Solarman — next steps when module is online

1. Confirm IP for MAC `28:9C:6E:82:E0:FE` (Fritz / `arp -a` / `ip neigh`). Prefer a **Fritz static DHCP lease**.
2. Check local port: TCP **8899** (Solarman protocol). If only HTTP works, set internal server port via logger UI / `config_hide.html`.
3. HA entry **Solarman PV** already points at `192.168.57.89` — reload when reachable, or reconfigure host if DHCP moved.
4. Use profile **Auto** (or matching Deye/Sofar YAML). Logger **device serial** from stick UI if asked (not inverter SN).

## Energy dashboard

- Keep existing Shelly PV Mini return sensor if it measures the same feed carefully (avoid double-counting).
- Add Hoymiles port totals and/or a template sum once daytime values look right.
- Add Solarman production sensors once the module answers on 8899.

## Related

- Obsidian: `Haus & Haushalt/Home-Assistant.md` §7 / Integrations table
- Repo pointer: this file under `home-assistant/`
