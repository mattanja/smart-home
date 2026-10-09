# PV: Hoymiles + Solarman

## Status (2026-10-09)

| System | Host | Integration | Status |
|--------|------|-------------|--------|
| **Hoymiles** local | `192.168.57.104:10081` | [`hoymiles_wifi`](https://github.com/suaveolent/ha-hoymiles-wifi) | Local DTU polling |
| **Hoymiles** cloud | S-Miles (`mattanja+hoymiles@kern.services`) | [`hoymiles_nimbus`](https://github.com/wil-lem/ha-hoymiles-s-cloud) | **Configured** 2026-10-09 from Vault |
| **Solarman** inverter (+ WiFi) | MAC **`28:9C:6E:82:E0:FE`** ≈ `.89` | [`solarman`](https://github.com/davidrapan/ha-solarman) local; cloud needs `appId`/`appSecret` | Local offline last check; app login in Vault as **Solarman** |

**History:** Balcony inverter was **Bosswerk MI600** (Solarman stack). **Replaced by current Solarman inverter** — Vault *Wechselrichter Bosswerk MI600* is legacy (AP `10.10.100.254` / `.89` notes may still help for the logger UI).

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

## Cloud APIs (optional / backup)

Local Hoymiles already works. Cloud helps for Solarman (module often offline locally) and for daily/monthly plant aggregates.

### Hoymiles → S-Miles Cloud

| Need | What |
|------|------|
| Account | S-Miles Cloud / Hoymiles app **email + password** (same as [global.hoymiles.com](https://global.hoymiles.com) / app) |
| HA integration | e.g. [wil-lem/ha-hoymiles-s-cloud](https://github.com/wil-lem/ha-hoymiles-s-cloud) (PoC) or [Philra94/homeassistant-hoymiles-cloud](https://github.com/Philra94/homeassistant-hoymiles-cloud) (stronger on HYT+battery) |
| ioBroker alt | [`iobroker.hoymiles`](https://github.com/Eistee82/ioBroker.hoymiles) — local TCP **and** S-Miles cloud |

**Vault (2026-10-09):** Bitwarden item *com.hm.hemaiInstall1* → `mattanja+hoymiles@kern.services` + password (S-Miles / global.hoymiles.com). Ready to configure cloud HA once component is added.

### Solarman → Solarman Cloud API

| Need | What |
|------|------|
| App login | Vault / `_secret/info.md` — **Solarman** (`mattanja@kern.services`); URI `com.igen.xiaomaizhidian` |
| API keys | **appId + appSecret** still missing — request from `customerservice@solarmanpv.com` ([docs](https://doc.solarmanpv.com/en/Documentation%20and%20Quick%20Guide)) |
| Device | Logger/inverter **serial** from Solarman Smart app (deviceSn) |
| HA integration | [`solarman_api`](https://github.com/daspilker/home-assistant-solarman-api) **installed** on HA — config flow needs all 5 fields above |
| ioBroker alt | [`iobroker.solarmanpv`](https://github.com/raschy/ioBroker.solarmanpv) — same appId/secret |

Local stick integration (`davidrapan/ha-solarman` @ MAC `28:9C:6E:82:E0:FE`) stays preferred when TCP **8899** is reachable; cloud is the fallback while the module sleeps/offline.

### Recommended order

1. Keep **local Hoymiles** as primary realtime.
2. For Solarman: either wake/fix local `.89:8899` **or** request API keys + add `solarman-api` with app login.
3. Add Hoymiles cloud only if you want S-Miles daily/monthly stats beyond local sensors.

## Energy dashboard

- Keep existing Shelly PV Mini return sensor if it measures the same feed carefully (avoid double-counting).
- Add Hoymiles port totals and/or a template sum once daytime values look right.
- Add Solarman production sensors once local 8899 or cloud API works.

## Related

- Obsidian: `Haus & Haushalt/Home-Assistant.md` §7 / Integrations table
- Repo pointer: this file under `home-assistant/`
