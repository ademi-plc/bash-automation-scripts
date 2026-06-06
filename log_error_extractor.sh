#!/bin/sh
show_usage() {
	echo "Usage: $0 <log_file>"
	echo "Example: $0 /var/log/syslog"
}
if [ -z "$1" ]; then
	echo "ERROR: log file not specified"
	show_usage 
	exit 1
fi
LOG_FILE="$1"
if [ ! -f "$LOG_FILE" ]; then
	echo "ERROR: file '$LOG_FILE' not found"
	exit 1
fi
DATE=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="errors_${DATE}.log"
echo "Searching for errors in: $LOG_FILE"
grep "ERROR" "$LOG_FILE" > "$OUTPUT_FILE"
ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE")
echo "Done!"
echo "Errors found: $ERROR_COUNT"
echo "Results saved to: $OUTPUT_FILE"
if [ $ERROR_COUNT -gt 0 ]; then
	echo ""
	echo "First error found:"
	echo "------------------------"
	head -1 "$OUTPUT_FILE"
	echo "------------------------"
fi
