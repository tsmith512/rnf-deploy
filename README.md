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
