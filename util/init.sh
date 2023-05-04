#!/usr/bin/env bash

# Move to the root of rnf-deploy
cd ${0%/*}/..

# Read project env vars
export $(grep -v '^#' .env | xargs)

# Stuff we need
sudo apt-get install emacs-nox s3cmd mariadb-client postgresql-client awscli jq mc byobu

# Pull in the WordPress repository
git clone git@github.com:tsmith512/routenotfound.git apache/docroot

# Set up NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# And we need to use it immediately
export NVM_DIR=$HOME/.nvm;
source $NVM_DIR/nvm.sh;

cd apache/docroot/wp-content/themes/rnf-alfa
git checkout dev
ln -s ../../../../../.env .env

echo "## Building theme assets"
nvm install
nvm use
npm install
npx gulp

cd ../../../../..

cp apache/docroot/wp-config-sample.php apache/docroot/wp-config.php
rm -f apache/docroot/salt.php
touch apache/docroot/salt.php
echo "<?php" > apache/docroot/salt.php
curl https://api.wordpress.org/secret-key/1.1/salt/ >> apache/docroot/salt.php

echo "## Building Docker conainers"
docker compose create --build

echo "## Installing systemd service unit"
sudo ln -s $(realpath rnf.service) /etc/systemd/system/rnf.service
sudo systemctl enable rnf
sudo systemctl start rnf

echo "## Running restore script"
util/restore.sh
