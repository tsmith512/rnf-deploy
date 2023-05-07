```
              _                  _      __                  _
 _ _ ___ _  _| |_ ___   _ _  ___| |_   / _|___ _  _ _ _  __| |
| '_/ _ \ || |  _/ -_) | ' \/ _ \  _| |  _/ _ \ || | ' \/ _` |
|_| \___/\_,_|\__\___| |_||_\___/\__| |_| \___/\_,_|_||_\__,_|

RNF Deploy

```

# RNF Deploy

Parent repository for the Docker Compose build for the LAMP stack for WordPress
and the PostgreSQL/PostGIS/PostgREST combo for the location tracker.

See also:

- https://github.com/tsmith512/routenotfound -- The WordPress codebase which
  should be unpacked to apache/docroot
- https://github.com/tsmith512/rnf-location-service -- The Worker middleware that
  provides the frontend API and connects to PostgREST on this stack
- https://github.com/tsmith512/rnf-location-admin -- The React App to admin the
  location data

## Setup

- Run Ubuntu setup for docker and ensure current user in `docker` group
- Clone this repo
- Create/populate `~.aws/credentials` for its owner
  - User will need R2 credentials (read/write)
- Create `.env` from `.env.sample` in the root
  - Provision a Cloudflare tunnel token
- Download the latest backup archive to `backup/`
- Run `util/init.sh` (sudo password will be immediately requested)
- Go to Cloudflare Zero Trust and add the following routes:
  - PostgREST: http://routenotfound-postgrest-1:3000
  - Apache: https://routenotfound-apache-1:443
    - With option "No TLS Verify" enabled
- The rnf-location-service Worker needs a `DB_ADMIN_JWT` env/secret
  - Payload is `{ "role": "admin_requests" }`
  - The signature is whatever you put in `.env`
- Add these two lines to cron:
  - `m    h  dom mon dow   command`
  - `*/15 *  *   *   *     curl -o - https://www.routenotfound.com/wp-cron.php`
  - `0    6  *   *   1,4   ~/rnf-deploy/backup.sh`
