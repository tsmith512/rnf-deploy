#!/bin/bash

# Move to the root of rnf-deploy
cd ${0%/*}/..

# Read project env vars
export $(grep -v '^#' .env | xargs)

# Load in the AWS creds for s3cmd
export AWS_CREDENTIAL_FILE=~/.aws/credentials

rm -rf backup/current
mkdir -p backup/current
TODAY=$(date +%Y%m%d)
BACKUP_FILE="backup/backup-$TODAY.tgz"

echo Dump WordPress Database
mysqldump -u $MS_USER -p$MS_PASSWD -h $(util/ip.sh mariadb) rnf_content > backup/current/database.sql

# Copy the location database
echo Pull PostgreSQL location history database and structure
pg_dump -c --if-exists --no-owner postgres://$PG_USER:$PG_PASSWD@$(util/ip.sh postgres)/rnf_location > backup/current/location_history.psql
pg_dump --schema-only --no-owner postgres://$PG_USER:$PG_PASSWD@$(util/ip.sh postgres)/rnf_location > backup/current/structure.psql

# Get a tarball of the docroot and a dump of the db
echo Archiving site docroot
tar -czf "$BACKUP_FILE" -C apache docroot -C ../backup/current database.sql location_history.psql structure.psql

# Send to R2 (will be automatically purged after 36 days by lifecycle rule)
aws s3 cp "$BACKUP_FILE" s3://backups-rnf/ --endpoint-url ${R2_ENDPOINT}

rm "$BACKUP_FILE"
