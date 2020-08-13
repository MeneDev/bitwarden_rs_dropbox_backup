#!/bin/sh

# create backup filename
BACKUP_FILE="db.sqlite3_$(date "+%F-%H%M%S")"
SOURCE_FILE="${SOURCE_FILE:-/db.sqlite3}"

TMP_FOLDER="$(mktemp -d)"
# use sqlite3 to create backup (avoids corruption if db write in progress)
sqlite3 "${SOURCE_FILE}" ".backup '${TMP_FOLDER}/db.sqlite3'"

# tar up backup and encrypt with openssl and encryption key
tar -czf - "${TMP_FOLDER}/db.sqlite3" | openssl enc -e -aes256 -salt -pbkdf2 -pass "pass:${BACKUP_ENCRYPTION_KEY}" -out "${TMP_FOLDER}/${BACKUP_FILE}.tar.gz"

# upload encrypted tar to dropbox
/dropbox_uploader.sh -d upload "${TMP_FOLDER}/${BACKUP_FILE}.tar.gz" "/${BACKUP_FILE}.tar.gz"

# cleanup tmp folder
rm -rf /tmp/*