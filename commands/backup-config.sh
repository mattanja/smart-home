#!/bin/sh
# Backup smart-home config that is not (or not fully) in git.
# Run on corenetstorage (or via: ssh mattanja@corenetstorage ~/bin/dc ...).
# Example:
#   /share/CACHEDEV2_DATA/data/smart-home/commands/backup-config.sh
#   /share/CACHEDEV2_DATA/data/smart-home/commands/backup-config.sh /share/Backup/smart-home

set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
DEST="${1:-$ROOT/archive/config-backups}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="$DEST/smart-home-config-$STAMP.tar.gz"

mkdir -p "$DEST"

# Intentionally excludes large DBs / secrets unless you pass --with-secrets
WITH_SECRETS=0
for arg in "$@"; do
  [ "$arg" = "--with-secrets" ] && WITH_SECRETS=1
done

INCLUDE="
home-assistant/configuration.yaml
home-assistant/automations.yaml
home-assistant/scripts.yaml
home-assistant/scenes.yaml
home-assistant/mqtt.yaml
home-assistant/templates.yaml
home-assistant/dashboards.yaml
home-assistant/secrets.yaml
home-assistant/.storage
docker-compose.yml
template.env
.gitignore
README.md
mosquitto/config
"

EXCLUDE="--exclude=home-assistant/.storage/auth --exclude=home-assistant/.storage/auth_provider*"

if [ "$WITH_SECRETS" -eq 1 ]; then
  INCLUDE="$INCLUDE
.env
_secret
"
fi

# shellcheck disable=SC2086
tar -czf "$OUT" -C "$ROOT" $EXCLUDE $INCLUDE 2>/dev/null || \
  tar -czf "$OUT" -C "$ROOT" \
    home-assistant/configuration.yaml \
    home-assistant/automations.yaml \
    home-assistant/scripts.yaml \
    home-assistant/scenes.yaml \
    home-assistant/mqtt.yaml \
    home-assistant/templates.yaml \
    home-assistant/dashboards.yaml \
    home-assistant/secrets.yaml \
    docker-compose.yml \
    template.env \
    .gitignore \
    README.md

echo "Wrote $OUT"
ls -lh "$OUT"
