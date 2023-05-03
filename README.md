# rnf-deploy

## Setup

- Run Ubuntu setup for docker and ensure current user in `docker` group
- Clone this repo
- Create/populate `~.aws/credentials` for its owner
  - User will need R2 credentials
- Create `.env` from `.env.sample` in the root
  - Provision a Cloudflare tunnel token
- Download the latest backup archive to `backup/`
- Run `util/init.sh` (sudo password will be immediately requested)
  - TODO: This breaks half-way through restore because there's no wp-config at this point
- Go to Cloudflare Zero Trust and add the following routes:
  - PostgREST: http://routenotfound-postgrest-1:3000
  - Apache: https://routenotfound-apache-1:443
    - With option "No TLS Verify" enabled
  - (WIP: WordPress HTTP??)
