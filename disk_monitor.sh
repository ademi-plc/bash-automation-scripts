#!/bin/bash

THRESHOLD=90
DISK_PARTITION="/"
TELEGRAM_BOT_TOKEN="<your token>"
TELEGRAM_CHAT_ID="<your_chat_id>"
mkdir -p "$HOME/logs"
LOG_FILE="$HOME/logs/disk_monitor.log"

send_telegram() {
	local message="$1"
	local url="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"
	
	curl -s -X POST "$url" \
		-d "chat_id=${TELEGRAM_CHAT_ID}" \
		-d "text=${message}" \
		-d "parse_mode=HTML" > /dev/null 2>&1
}

write_log() {
	local message="$1"
	local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
	echo "[${timestamp}] ${message}" >> "$LOG_FILE"
}

get_disk_usage() {
	df "$DISK_PARTITION" | tail -1 | awk '{print $5}' | sed 's/%//'
}

get_disk_details() {
	df -h "$DISK_PARTITION" | tail -1
}

USAGE=$(get_disk_usage)
DISK_INFO=$(get_disk_details)
HOSTNAME=$(hostname)

ALERT_MESSAGE="<b>DISK SPACE ALERT</b>
<b>Server:</b> ${HOSTNAME}
<b>Partition:</b> ${DISK_PARTITION}
<b>Disk usage:</b> ${USAGE}%
<b>Threshold:</b> ${THRESHOLD}%
<b>Details:</b> ${DISK_INFO}"

SUCCESS_MESSAGE="<b>Disk Monitor Check</b>
<b>Server:</b> ${HOSTNAME}
<b>Partition:</b> ${DISK_PARTITION}
<b>Disk usage:</b> ${USAGE}%
<b>Status:</b> Normal (below ${THRESHOLD}%)"

if [ "$USAGE" -ge "$THRESHOLD" ]; then
	send_telegram "$ALERT_MESSAGE"
	write_log "ALERT: Disk usage ${USAGE}% exceeds threshold ${THRESHOLD}% on ${DISK_PARTITION}"
	write_log "Alert sent to Telegram"
	echo "ALERT: Disk usage ${USAGE}% exceeds threshold ${THRESHOLD}%"
	echo "Alert sent to Telegram"
else
	send_telegram "$SUCCESS_MESSAGE"
	write_log "OK: Disk usage ${USAGE}% is below threshold ${THRESHOLD}%"
	echo "OK: Disk usage ${USAGE}% is below threshold ${THRESHOLD}%"
fi

echo "Log saved to: $LOG_FILE"

