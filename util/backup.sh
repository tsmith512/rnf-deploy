#!/bin/bash

# Move to the root of rnf-deploy
cd ${0%/*}/..

# Read project env vars
export $(grep -v '^#' .env | xargs)

# Load in the AWS creds for s3cmd
export AWS_CREDENTIAL_FILE=~/.aws/credentials

# This script terminates with the latest dump still sitting in this folder.
# I would like to keep the most recent backup locally for easy reference
# and transfer back to staging or dev.
rm -rf backup/current
mkdir -p backup/current

TODAY=$(date +%Y%m%d)

# Get a tarball of the docroot and a dump of the db
echo Build tarball of the site docroot
tar -cf backup/current/docroot.tar -C apache docroot

#~/.config/composer/vendor/bin/wp db export --path=wp ~/rnf/backups/database.sql
echo Pull WordPress content database
#docker exec -u www-data $(util/id.sh) /usr/local/bin/wp-cli db export --path=/var/www/html/wp > backup/current/database.sql
mysqldump -u $MS_USER -p$MS_PASSWD -h $(util/ip.sh mariadb) rnf_content > backup/current/database.sql

# Copy the location database
echo Pull PostgreSQL location history database
pg_dump -c --if-exists --no-owner postgres://$PG_USER:$PG_PASSWD@$(util/ip.sh postgres)/rnf_location > backup/current/location_history.psql

# Combine them in a date-stamped file
#tar -zcf ~/rnf/backups/backup-$TODAY.tgz -C ~/rnf/backups/ docroot.tar database.sql location_history.psql
echo Combining and compressing backup components
tar -zcf backup/backup-$TODAY.tgz -C backup/current docroot.tar database.sql location_history.psql

# Send to S3
#s3cmd put ~/rnf/backups/backup-$TODAY.tgz s3://tsmith-backups/routenotfound/

# And leave them there until the next execution.
