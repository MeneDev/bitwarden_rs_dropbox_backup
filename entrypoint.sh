#!/bin/sh

# setup dropbox uploader config file
echo "OAUTH_ACCESS_TOKEN=${DROPBOX_ACCESS_TOKEN}" > ~/.dropbox_uploader

# setup cron, default to daily
CRON_SPEC="${CRON_SPEC:-0 1 * * *}"
echo "${CRON_SPEC} /backup.sh" > /etc/crontabs/root

# run backup once on container start to ensure it works
/backup.sh

# start crond in foreground
exec crond -f