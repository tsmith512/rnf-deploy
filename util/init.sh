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
source ~/.bashrc

cd apache/docroot/wp-content/themes/rnf-alfa
git checkout dev
ln -s ../../../../../.env .env

# @TODO: This didn't work, nvm was still undefined
echo "Navigate to the theme, nvm install/use, npm install, npx gulp"
nvm install
nvm use
npm install
npx gulp

# @TODO: Need to make this in a way that doesn't hard-code paths
#sudo ln -s /home/tsmith/rnf-deploy/rnf.service /etc/systemd/system/rnf.service
echo Link the systemd service unit and enable

echo Next, start the Compose stack, pull a backup archive, and run util/restore.sh

