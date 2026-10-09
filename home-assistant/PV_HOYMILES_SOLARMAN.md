# PV: Hoymiles + Solarman

## Status (2026-10-09)

| System | Host | Integration | Status |
|--------|------|-------------|--------|
| **Hoymiles** (WiFi DTU / HMS) | `192.168.57.104` (`espressif`) port **10081** | HACS custom [`hoymiles_wifi`](https://github.com/suaveolent/ha-hoymiles-wifi) | **Live** — AC/DC power, per-port Wh totals |
| **Solarman** stick | `192.168.57.36` (`Dongle-M-94C8`) | HACS custom [`solarman`](https://github.com/davidrapan/ha-solarman) | **Blocked** — only TCP **80** open; local protocol needs **8899** |

These are separate plants/loggers (not duplicates of each other). Shelly **PV Mini Power Meter** remains an independent meter already used in the Energy dashboard.

## Install (already done on live `/config`)

Components live under `custom_components/` (gitignored, like other HACS installs):

- `hoymiles_wifi` ← [suaveolent/ha-hoymiles-wifi](https://github.com/suaveolent/ha-hoymiles-wifi)
- `solarman` ← [davidrapan/ha-solarman](https://github.com/davidrapan/ha-solarman)

For updates: add both as HACS **custom repositories** (category Integration), then update via HACS.

## Hoymiles — useful entities

- Power: `sensor.inverter_ac_power`
- Energy (Energy dashboard): per-port `sensor.inverter_port_N_dc_total_energy` (Wh, `total_increasing`)
- Nightly power is often `0`; totals still accumulate

Config entry host: `192.168.57.104`, update interval **35 s** (keep ≥ ~32 s so S-Miles cloud keeps working).

## Solarman — unblock local access

1. Open logger UI: http://192.168.57.36/ (login; often `admin`/`admin` on older sticks — this stick uses a modern SPA).
2. Prefer hidden page: http://192.168.57.36/config_hide.html → **Internal server** port → set **8899**, save/reboot.
3. Confirm from HA host: TCP `192.168.57.36:8899` open.
4. Settings → Devices & services → **Solarman PV** (entry may be in *Retry*): reload, or remove and re-add with host `.36`, port `8899`, profile **Auto** (or the matching Deye/Sofar YAML).
5. Note logger **device serial** from the stick UI (not inverter SN) if the flow asks for it.

Alternative if local port stays closed: Solarman cloud API (`service@solarmanpv.com` for `app_id` / `app_secret`) via ioBroker `solarmanpv` — not preferred while local HA is the goal.

## Energy dashboard

- Keep existing Shelly PV Mini return sensor if it measures the same feed carefully (avoid double-counting).
- Add Hoymiles port totals and/or a template sum once daytime values look right.
- Add Solarman production sensors after 8899 works.

## Related

- Obsidian: `Haus & Haushalt/Home-Assistant.md` §7 / Integrations table
- Repo pointer: this file under `home-assistant/`
