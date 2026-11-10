#!/usr/bin/env bash
# Home Assistant / smart-home → Borg (+ rsync HA native backups) → Hetzner Storage Box.
#
# Layout on u360280 (sub5 home = backups/home-assistant):
#   borg-repo/     encrypted Borg repository
#   ha-native/     rsync of /config/backups/*.tar from HA
#
# Secrets on Mac (mode 600, not in git):
#   ~/.config/homeassistant/borg.passphrase
#   ~/.config/homeassistant/borg-key-export.txt   # also store in Bitwarden
#   ~/.config/homeassistant/ha-backup.password    # HA native backup encryption
#   ~/.ssh/id_ed25519_ha_restic                  # SSH key for u360280-sub5
#
# Usage (Mac, live share mounted):
#   bash /Volumes/data/smart-home/commands/backup-borg.sh
#   bash /Volumes/data/smart-home/commands/backup-borg.sh --skip-native
#   bash /Volumes/data/smart-home/commands/backup-borg.sh --dry-run

set -euo pipefail

LIVE="${LIVE:-/Volumes/data/smart-home}"
NAS_HOST="${NAS_HOST:-mattanja@corenetstorage}"
NAS_LIVE="${NAS_LIVE:-/share/CACHEDEV2_DATA/data/smart-home}"
HOST_TAG="${HOST_TAG:-corenetstorage}"
export BORG_REPO="${BORG_REPO:-ssh://u360280-sub5@u360280.your-storagebox.de:23/./borg-repo}"
export BORG_PASSCOMMAND="${BORG_PASSCOMMAND:-cat $HOME/.config/homeassistant/borg.passphrase}"
export BORG_REMOTE_PATH="${BORG_REMOTE_PATH:-borg-1.4}"
export BORG_RSH="${BORG_RSH:-ssh -i $HOME/.ssh/id_ed25519_ha_restic -p 23 -o IdentitiesOnly=yes}"

NATIVE_SRC="${NATIVE_SRC:-$LIVE/home-assistant/backups}"
NATIVE_DST="${NATIVE_DST:-u360280-sub5:ha-native/}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519_ha_restic}"

SKIP_NATIVE=0
SKIP_BORG=0
DRY_RUN=0
DO_PRUNE=1
for arg in "$@"; do
  case "$arg" in
    --skip-native) SKIP_NATIVE=1 ;;
    --skip-borg) SKIP_BORG=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --no-prune) DO_PRUNE=0 ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
  esac
done

if [[ ! -d "$LIVE/home-assistant" ]]; then
  echo "ERROR: missing $LIVE/home-assistant" >&2
  exit 1
fi
if [[ ! -f "$HOME/.config/homeassistant/borg.passphrase" ]]; then
  echo "ERROR: missing borg.passphrase" >&2
  exit 1
fi

log() { echo "$(date '+%Y-%m-%dT%H:%M:%S%z') $*"; }

# Stage root-only .storage / mosquitto files via docker on NAS (SMB cannot read them).
stage_root_only_files() {
  log "==> stage root-only files via $NAS_HOST"
  ssh "$NAS_HOST" "export PATH=\"/share/CACHEDEV1_DATA/.qpkg/container-station/usr/bin:\$PATH\"
ROOT='$NAS_LIVE'
STAGE=\"\$ROOT/home-assistant/.borg-extra\"
rm -rf \"\$STAGE\"
mkdir -p \"\$STAGE/.storage\" \"\$STAGE/mosquitto-private\"
docker cp homeassistant:/config/.storage/auth \"\$STAGE/.storage/auth\"
docker cp homeassistant:/config/.storage/auth_provider.homeassistant \"\$STAGE/.storage/auth_provider.homeassistant\" 2>/dev/null || true
docker cp homeassistant:/config/.storage/backup \"\$STAGE/.storage/backup\"
docker cp homeassistant:/config/.storage/http \"\$STAGE/.storage/http\"
docker cp homeassistant:/config/.storage/core.config \"\$STAGE/.storage/core.config\" 2>/dev/null || true
if [ -f \"\$ROOT/mosquitto/config/private.d/dynamic-security.json\" ]; then
  docker run --rm -v \"\$ROOT/mosquitto/config/private.d:/in:ro\" alpine cat /in/dynamic-security.json \
    > \"\$STAGE/mosquitto-private/dynamic-security.json\"
fi
chown -R mattanja:everyone \"\$STAGE\" 2>/dev/null || true
chmod -R u+rwX,go-rwx \"\$STAGE\"
"
}

# --- 1) rsync HA native backup archives (encrypted .tar from HA Backup)
if [[ "$SKIP_NATIVE" -eq 0 ]]; then
  if [[ -d "$NATIVE_SRC" ]] && compgen -G "$NATIVE_SRC/*" >/dev/null; then
    log "==> rsync HA native backups → $NATIVE_DST"
    RSYNC_ARGS=(-avh --progress)
    [[ "$DRY_RUN" -eq 1 ]] && RSYNC_ARGS+=(--dry-run)
    rsync "${RSYNC_ARGS[@]}" \
      -e "ssh -i $SSH_KEY -p 23 -o IdentitiesOnly=yes" \
      "$NATIVE_SRC"/ "$NATIVE_DST"
  else
    log "WARN: no native backups in $NATIVE_SRC (create via HA Backup first)"
  fi
fi

# --- 2) Borg: full /config + compose/secrets needed to restore
if [[ "$SKIP_BORG" -eq 0 ]]; then
  if [[ "$DRY_RUN" -eq 0 ]]; then
    stage_root_only_files
  fi

  ARCHIVE="${HOST_TAG}-$(date -u +%Y-%m-%dT%H:%M:%S)"
  log "==> borg create $ARCHIVE"

  PATHS=(home-assistant docker-compose.yml template.env commands)
  [[ -f "$LIVE/.env" ]] && PATHS+=(.env)
  [[ -d "$LIVE/_secret" ]] && PATHS+=(_secret)
  [[ -d "$LIVE/mosquitto/config" ]] && PATHS+=(mosquitto/config)
  [[ -f "$LIVE/telegraf/telegraf.conf" ]] && PATHS+=(telegraf/telegraf.conf)

  EXCLUDES=(
    --exclude 'home-assistant/home-assistant.log*'
    --exclude 'home-assistant/*.log'
    --exclude 'home-assistant/deps'
    --exclude 'home-assistant/tts'
    --exclude 'home-assistant/backups'
    --exclude '**/__pycache__'
    --exclude '**/*.pyc'
    --exclude '**/.DS_Store'
  )

  CREATE_ARGS=(create --stats --compression zstd,3 "${EXCLUDES[@]}")
  [[ "$DRY_RUN" -eq 1 ]] && CREATE_ARGS+=(--dry-run)

  (
    cd "$LIVE"
    borg "${CREATE_ARGS[@]}" "::$ARCHIVE" "${PATHS[@]}"
  )

  if [[ "$DRY_RUN" -eq 0 && "$DO_PRUNE" -eq 1 ]]; then
    log "==> borg prune/compact (7d / 4w / 12m)"
    borg prune --list --glob-archives "${HOST_TAG}-*" \
      --keep-daily 7 --keep-weekly 4 --keep-monthly 12
    borg compact
  fi

  log "==> borg list"
  borg list
fi

log "OK"
