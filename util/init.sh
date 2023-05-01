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

nvm install
nvm use
npm install
npx gulp

echo Next, start the Compose stack, pull a backup archive, and run util/restore.sh

