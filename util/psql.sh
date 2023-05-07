#!/usr/bin/env bash

# Move to the root of rnf-deploy
cd ${0%/*}/..

# Read project env vars
export $(grep -v '^#' .env | xargs)

psql postgres://$PG_USER:$PG_PASSWD@$(util/ip.sh postgres)/rnf_location
