FROM postgis/postgis:10-2.5

ENV POSTGIS_MAJOR 2.5
ENV POSTGIS_VERSION 2.5.4+dfsg-1.pgdg90+1

# RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./init.sql /docker-entrypoint-initdb.d/20_rnf_init.sql
