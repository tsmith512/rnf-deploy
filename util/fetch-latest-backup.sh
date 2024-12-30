#!/bin/bash

# Move to the root of rnf-deploy
cd ${0%/*}/..

# Read project env vars
export $(grep -v '^#' .env | xargs)

# Load in the AWS creds for s3cmd
export AWS_CREDENTIAL_FILE=~/.aws/credentials

# They're date-ordered, so pull the list and fetch the last one's filename
FILE=$(aws s3 ls s3://backups-rnf/ --endpoint-url ${R2_ENDPOINT} | tail -n 1 | awk '{print $4}')

# And copy into the backup directory
aws s3 cp s3://backups-rnf/$FILE ./backup/ --endpoint-url ${R2_ENDPOINT}
