# Bash Automation Scripts

A collection of useful Bash scripts for everyday file management tasks.

## 1. File Organizer (`FileOrganizer.sh`)
Sorts files in the current folder into subfolders: images/, docs/, others/.

Usage:
chmod +x FileOrganizer.sh
./FileOrganizer.sh

2. Log Error Extractor (log_error_extractor.sh)

Searches for lines containing "ERROR" in a log file and saves them to a timestamped file.

Usage:
chmod +x log_error_extractor.sh
./log_error_extractor.sh /path/to/logfile

3. Backup Script (backup.sh)

Creates a compressed .tar.gz backup of a folder, saves it to ~/backups/, and automatically deletes backups older than 7 days.

Usage:
chmod +x backup.sh
./backup.sh /path/to/folder

4. Disk Monitor with Telegram Alerts (disk_monitor.sh)

Checks disk usage on a partition (e.g., /) and sends a Telegram notification if usage exceeds a threshold (default 90%). Logs results to ~/logs/disk_monitor.log.

Features:

· Sends alert or OK message with HTML formatting
· Uses Telegram Bot API
· Logs with timestamps

Usage:
chmod +x disk_monitor.sh
# Edit the script and set your TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID
./disk_monitor.sh

Setup Telegram:

1. Create a bot via @BotFather and get the token.
2. Get your chat ID via @userinfobot.
3. Replace <your token> and <your_chat_id> in the script.

Automation with cron:
crontab -e
# Add line to run every hour:
0 * * * * /home/your_user/disk_monitor.sh

Requirements

· Linux / macOS / WSL
· Standard tools: tar, grep, find, stat, sed
