#!/usr/bin/env bash

# Move to the root of rnf-deploy
cd ${0%/*}/..

# Read project env vars
export $(grep -v '^#' .env | xargs)

# Unpack the most recent backup archive
# @TODO: Would be neat to accept this as an argument if provided
rm -rf backup/restore
mkdir -p backup/restore
tar -zxf $(ls -1 backup/backup* | tail -n 1) -C backup/restore

# Load WordPress content into the mysql
mariadb -h $(util/ip.sh mariadb) -u $MS_USER -p$MS_PASSWD rnf_content <  backup/restore/database.sql

# Load location history into postgres
psql postgres://$PG_USER:$PG_PASSWD@$(util/ip.sh postgres)/rnf_location < backup/restore/location_history.psql

# Unpack wordpress uploads into the doc root
rm -rf apache/docroot/wp-content/uploads
tar -xvf backup/restore/docroot.tar -C apache/docroot --transform 's/rnf-prod\///' rnf-prod/wp-content/uploads

# UNCOMMENT THIS TO RELACE WP-CONFIG
# tar -xvf backup/restore/docroot.tar -C apache/docroot --transform 's/rnf-prod\///' rnf-prod/wp-config.php

# Update composer dependencies
sudo docker exec -w /var/www/html -it $(util/id.sh) /usr/local/bin/composer install

# @TODO: Other docroot folders are ignored. Could also git checkout or
# update/downgrate dependencies...

docker exec -u www-data $(sudo ./util/id.sh) /usr/local/bin/wp-cli search-replace "www.routenotfound.com" $WEBHOST --path=/var/www/html/wp

rm -rf backup/restore
