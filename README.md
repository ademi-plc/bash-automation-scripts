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

Requirements

· Linux / macOS / WSL
· Standard tools: tar, grep, find, stat, sed
