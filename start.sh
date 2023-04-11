#!/bin/sh

# https://www.codementor.io/@akul08/the-ultimate-crontab-cheatsheet-5op0f7o4r

# Create the settings file with the environment variables
cat << EOF > /settings.sh
export GITHUB_REPO="$GITHUB_REPO"
export GITHUB_BRANCH="$GITHUB_BRANCH"
export GIT_USER_NAME="$GIT_USER_NAME"
export GIT_USER_EMAIL="$GIT_USER_EMAIL"
export GIT_SRC="$GIT_SRC"
export GITHUB_USERNAME="$GITHUB_USERNAME"
export GITHUB_ACCESS_TOKEN="$GITHUB_ACCESS_TOKEN"
export FILES_TO_COMMIT="$FILES_TO_COMMIT"
export COMMIT_MSG="$COMMIT_MSG"
export PRE_BACKUP_SCRIPT="$PRE_BACKUP_SCRIPT"
EOF
chmod +x /settings.sh

# Set the default backup frequency if not provided
BACKUP_FREQUENCY="${BACKUP_FREQUENCY:-'0 5 * * *'}"
echo "Running using cron frequency:"
echo "minute hour day(month) month day(of-week)"
echo "$BACKUP_FREQUENCY"
echo '----------'

# Create the cronjob file
mkdir -p /etc/cron.d
echo "$BACKUP_FREQUENCY BASH_ENV=/settings.sh /app/backup $@ > /proc/1/fd/1 2>/proc/1/fd/2" > /etc/cron.d/backup_cronjob
chmod 0644 /etc/cron.d/backup_cronjob
crontab /etc/cron.d/backup_cronjob

# Run the cron daemon
/usr/sbin/crond -f -l 2
