#!/bin/sh
show_usage() {
	echo "Usage: $0 <folder_path>"
	echo "Example: $0 /home/user/documents"
	echo "Example: $0 ./my_project"
}
if [ -z "$1" ]; then
	echo "ERROR: folder not specified"
	show_usage
	exit 1
fi
SOURCE_DIR="$1"
SOURCE_DIR=$(echo "$SOURCE_DIR" | sed 's:/*$::')
if [ ! -d "$SOURCE_DIR" ]; then
	echo "ERROR: folder '$SOURCE_DIR' not found"
	exit 1
fi
BACKUP_DIR="$HOME/backups"
mkdir -p "$BACKUP_DIR"
FOLDER_NAME=$(basename "$SOURCE_DIR")
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/backup_${FOLDER_NAME}_${DATE}.tar.gz"
echo "========================================="
echo "Backup started"
echo "Source: $SOURCE_DIR"
echo "Destination: $BACKUP_FILE"
echo "========================================="
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$FOLDER_NAME"
if [ $? -eq 0 ]; then
	echo "SUCCESS: Backup created"
	SIZE=$(stat -c%s "$BACKUP_FILE" 2>/dev/null || stat -f%z "$BACKUP_FILE" 2>/dev/null)
	if [ -n "$SIZE" ]; then
		SIZE_MB=$((SIZE / 1024 / 1024))
		echo "Size: ${SIZE_MB} MB"
	fi
else
	echo "ERROR: Backup failed"
	exit 1
fi
echo ""
echo "Cleaning old backups (older than 7 days)..."
DELETED_COUNT=$(find "$BACKUP_DIR" -name "backup_${FOLDER_NAME}_*.tar.gz" -type f -mtime +7 -delete -print | wc -l)
echo "Deleted old backups: $DELETED_COUNT"
echo ""
echo "Done!"
echo "Backup saved to: $BACKUP_FILE"

