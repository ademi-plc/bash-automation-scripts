# What I learned while writing backup.sh

I wrote this script step by step, and here are the most important things I learned.

---

## Removing trailing slashes with sed

SOURCE_DIR=$(echo "$SOURCE_DIR" | sed 's:/*$::')

· s means substitute (replace)
· : is the separator (instead of usual /, to avoid escaping)
· /*$ matches zero or more slashes at the end of the string
· $ means "end of line"
· So it removes any trailing slashes from the folder path.

---

Using $HOME variable

BACKUP_DIR="$HOME/backups"

· $HOME is an environment variable that stores the path to the current user's home directory
· Example: for user vasya, $HOME is /home/vasya
· This makes the script work on any machine without hardcoding paths.

---

basename – get the last part of a path

FOLDER_NAME=$(basename "$SOURCE_DIR")

· basename strips the leading path and returns just the folder/file name
· Example: /home/vasya/docs → docs
· Very useful for naming backups.

---

Building the backup filename

BACKUP_FILE="${BACKUP_DIR}/backup_${FOLDER_NAME}_${DATE}.tar.gz"

· ${BACKUP_DIR} – path where backups are stored
· ${FOLDER_NAME} – name of the source folder
· ${DATE} – current timestamp (e.g., 20250606_153000)
· .tar.gz – extension: tar bundles files, gzip compresses them
· The curly braces {} are not always needed, but they help avoid confusion and work in all cases.

---

The tar command with -C option

tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$FOLDER_NAME"

· tar – archiving tool
· -c – create archive
· -z – compress with gzip (makes .tar.gz)
· -f – specify archive filename
· -C – temporarily change to directory $(dirname "$SOURCE_DIR") before archiving
· dirname is the opposite of basename: removes the last component, returns parent directory
· This ensures the archive contains $FOLDER_NAME without full absolute path inside.

---

Checking command success with $?

if [ $? -eq 0 ]; then

· $? – special variable holding the exit code of the last command
· 0 means success, anything >0 means error
· -eq – numeric equality comparison (equal)
· This checks if tar succeeded.

---

Getting file size with stat (cross-platform trick)

SIZE=$(stat -c%s "$BACKUP_FILE" 2>/dev/null || stat -f%z "$BACKUP_FILE" 2>/dev/null)

· stat -c%s – works on Linux, prints size in bytes
· 2>/dev/null – redirects error messages to nowhere (silent)
· || – if the first command fails, try the second
· stat -f%z – works on macOS/BSD
· This makes the script work on both Linux and macOS.

---

Checking if a string is non‑empty with -n

if [ -n "$SIZE" ]; then

· -n tests if the string length is greater than zero (not empty)
· If $SIZE has a value (i.e., stat succeeded), we can use it.

---

Deleting old backups with find

DELETED_COUNT=$(find "$BACKUP_DIR" -name "backup_${FOLDER_NAME}_*.tar.gz" -type f -mtime +7 -delete -print | wc -l)

· find "$BACKUP_DIR" – search in backup directory
· -name "backup_${FOLDER_NAME}_*.tar.gz" – pattern to match
· -type f – only regular files (not directories)
· -mtime +7 – files older than 7 days
· -delete – delete them
· -print – output the deleted filenames
· wc -l – count lines (how many files were deleted)
· This whole construct counts and deletes old backups in one line.

---

Summary

Writing this script taught me:

· path manipulation (basename, dirname, sed)
· environment variables ($HOME)
· exit codes and conditional checks
· cross‑platform compatibility (stat fallback)
· powerful find with deletion and counting
· how to write robust shell scripts with error handling

I'm ready to write more automation scripts for real tasks.
