#!/usr/bin/env bash
# Scheduled entry point for Mac launchd: HA native backup → Borg/rsync offsite.
# Skips cleanly when the live share is not mounted (laptop away from LAN).

set -euo pipefail

LIVE="${LIVE:-/Volumes/data/smart-home}"
LOG_DIR="${LOG_DIR:-$HOME/Library/Logs/homeassistant}"
ENV_FILE="${ENV_FILE:-$HOME/.config/homeassistant/env}"
mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/backup-borg.log"

exec >>"$LOG" 2>&1
log() { echo "$(date '+%Y-%m-%dT%H:%M:%S%z') $*"; }

log "==== scheduled backup start ===="

if [[ ! -d "$LIVE/home-assistant" ]]; then
  log "SKIP: live share not mounted at $LIVE"
  exit 0
fi

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

if [[ -n "${HASS_SERVER:-}" && -n "${HASS_TOKEN:-}" ]]; then
  NAME="Scheduled_$(date +%Y-%m-%d_%H%M)"
  log "==> HA native backup: $NAME"
  # Fire-and-forget; HA writes encrypted .tar into /config/backups
  code=$(curl -sS -o /tmp/ha-backup-create.json -w "%{http_code}" \
    -X POST "$HASS_SERVER/api/services/backup/create" \
    -H "Authorization: Bearer $HASS_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{}") || code="curl_fail"
  log "backup.create HTTP $code $(tr -d '\n' </tmp/ha-backup-create.json 2>/dev/null | head -c 200)"
  # Give HA a few minutes to finish packing before rsync
  sleep 180
else
  log "WARN: HASS_SERVER/HASS_TOKEN missing — skipping HA native create"
fi

bash "$LIVE/commands/backup-borg.sh"
log "==== scheduled backup done ===="
