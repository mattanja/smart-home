# Cameras & Fiat — integration notes (2026-10-09)

## Cameras

| Device | IP | Model | Integration | Stream |
|--------|-----|-------|-------------|--------|
| Eingang | 192.168.57.55 (`ipc.fritz.box`) | Wired Tapo (RTSP) | HA **Generic Camera** (+ go2rtc) | `rtsp://…/stream1` on port **554** |
| C460 | 192.168.57.117 (`c460.fritz.box`) | **Tapo C460** (battery/solar) | HACS **Tapo: Cameras Control** (`tapo_control` 7.2.7) | **No RTSP** — proprietary stream on **443 / 8800** |

### Why C460 is different

TP-Link documents that battery/solar models (C425, **C460**, C660, …) generally **do not support RTSP/ONVIF**. Cloning the Generic Camera config from Eingang therefore cannot work.

### Finish C460 setup (UI — needs Tapo account)

Component is already installed under `custom_components/tapo_control`.

1. HA → **Settings → Devices & services → Add integration**
2. Search **Tapo: Cameras Control**
3. Prefer **IP address** `192.168.57.117` (cloud login may be required once for battery cams)
4. Use the same TP-Link / Tapo account as in the Tapo app
5. Avoid continuous streaming/snapshots on battery models (drains battery)

Optional later: also add Eingang via `tapo_control` for motion binary sensors; keep Generic/go2rtc for low-latency RTSP if preferred.

## Fiat 500e in Home Assistant (vs ioBroker)

### Current state

- **ioBroker `fiat` adapter works** (SoC observed live, e.g. 88%).
- Script `script.js.common.Fiat500` still sends **Telegram** and contains legacy Easee logic (HA already drives Easee).
- **No Fiat/Uconnect custom component** was installed in HA before 2026-10-09 (earlier attempts likely failed against older APIs / paid MyCar / abandoned add-ons).

### Recommended HA path now

Install **[hass-uconnect](https://github.com/hass-uconnect/hass-uconnect)** via HACS (custom repository, type Integration):

- Pure Python HA integration for Fiat / Stellantis Uconnect (EU supported)
- Needs an **active Uconnect / My Car subscription** for remote data/commands
- Configure with Fiat Connect e-mail + password (+ PIN if commands desired)

If that works, migrate Companion notifications for SoC/charging from the ioBroker `Fiat500` script and stop using Telegram for the car.

### Does ioBroker hurt?

**No — keeping it is fine.** Cost is mainly RAM/CPU on the NAS and a bit of maintenance. It does not break HA.

Pragmatic plan:

1. Keep ioBroker while Fiat data is needed and until hass-uconnect is proven.
2. Once HA Uconnect covers sensors + alerts, disable `fiat` / `telegram` / unused scripts.
3. Only then consider removing the ioBroker container from compose (optional cleanup, not urgent).

