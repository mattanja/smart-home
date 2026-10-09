#!/bin/sh
# Mac-side backup of smart-home YAML/config (not giant DBs / auth).
# Run on the Mac with /Volumes/data/smart-home mounted (or set LIVE=).
#
#   /Volumes/data/smart-home/commands/backup-to-mac.sh
#   BACKUP_ROOT=~/Backups/smart-home /Volumes/data/smart-home/commands/backup-to-mac.sh

set -eu
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/Backups/smart-home}"
STAMP="$(date +%Y%m%d-%H%M%S)"
DEST="$BACKUP_ROOT/$STAMP"
LIVE="${LIVE:-/Volumes/data/smart-home}"

mkdir -p "$DEST/home-assistant" "$DEST/archive/config-backups" "$DEST/commands" "$DEST/secrets"
echo "Backing up into $DEST"

if [ ! -d "$LIVE/home-assistant" ]; then
  echo "ERROR: $LIVE not mounted" >&2
  exit 1
fi

# Fresh NAS-side tarball of key files
if [ -x "$LIVE/commands/backup-config.sh" ]; then
  "$LIVE/commands/backup-config.sh" "$LIVE/archive/config-backups" || true
fi

rsync -a "$LIVE/home-assistant/"*.yaml "$LIVE/home-assistant/"*.md "$DEST/home-assistant/" 2>/dev/null || true
rsync -a "$LIVE/docker-compose.yml" "$LIVE/template.env" "$LIVE/.gitignore" "$DEST/"
rsync -a "$LIVE/commands/" "$DEST/commands/"
rsync -a "$LIVE/archive/config-backups/" "$DEST/archive/config-backups/" 2>/dev/null || true
[ -f "$LIVE/.env" ] && rsync -a "$LIVE/.env" "$DEST/secrets/" || true
[ -d "$LIVE/_secret" ] && rsync -a "$LIVE/_secret/" "$DEST/secrets/_secret/" || true

# Keep last 10
ls -1dt "$BACKUP_ROOT"/20* 2>/dev/null | tail -n +11 | while read -r old; do rm -rf "$old"; done

echo "Done: $DEST"
du -sh "$DEST"
