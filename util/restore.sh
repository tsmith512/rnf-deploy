#!/usr/bin/env bash

# Move to the root of rnf-deploy
cd ${0%/*}/..

# Read project env vars
export $(grep -v '^#' .env | xargs)

# Unpack the most recent backup archive
# @TODO: Would be neat to accept this as an argument if provided
FILE=$(ls -1 backup/backup* | tail -n 1)
echo \#\# UNPACK ARCHIVE: $FILE
rm -rf backup/restore
mkdir -p backup/restore
tar -zxf $FILE -C backup/restore

# Load WordPress content into the mariadb
echo \#\# Load WordPress Content into MariaDB
mariadb -h $(util/ip.sh mariadb) -u $MS_USER -p$MS_PASSWD rnf_content <  backup/restore/database.sql

# Load location history into postgres
echo \#\# Load Location History into PostgreSQL
psql postgres://$PG_USER:$PG_PASSWD@$(util/ip.sh postgres)/rnf_location < backup/restore/location_history.psql

# Unpack wordpress uploads into the docroot
echo \#\# Unpack wp-content/uploads directory into docroot
docker exec -w /var/www/html/wp-content $(util/id.sh) chown -R $(id -u):$(id -u) uploads
rm -rf apache/docroot/wp-content/uploads
tar -xvf backup/restore/docroot.tar -C apache/docroot --transform 's/docroot\///' docroot/wp-content/uploads

echo \#\# Installing Composer and Mapbox dependencies

# Update composer dependencies
docker exec -w /var/www/html -it $(util/id.sh) /usr/local/bin/composer install

# Force post-update script from Composer
docker exec -w /var/www/html -it $(util/id.sh) /usr/local/bin/composer run-script post-update-cmd

# @TODO: Other docroot folders are ignored. Could also git checkout or
# update/downgrate dependencies...

echo \#\# Resetting production hostname to match local environment
docker exec -u www-data $(util/id.sh) /usr/local/bin/wp-cli search-replace "www.routenotfound.com" $WEBHOST --path=/var/www/html/wp

echo \#\# Setting ownership of uploads directory to container www-data
docker exec -w /var/www/html/wp-content $(util/id.sh) chown -R www-data:www-data uploads

rm -rf backup/restore
