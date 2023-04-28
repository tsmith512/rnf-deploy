--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE admin_requests;
ALTER ROLE admin_requests WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
CREATE ROLE rnf;
ALTER ROLE rnf WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;

-- @TODO: web_authenticator is for PostgREST to use, but compose.yml currently sets it to log in as "postgres"
-- instead, so web_authenticator essentially goes unused. Given network architecture, that is okay for MVP.
CREATE ROLE web_authenticator;
ALTER ROLE web_authenticator WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;

CREATE ROLE web_requests;
ALTER ROLE web_requests WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
ALTER ROLE web_authenticator SET "pgrst.db_schema" TO 'public';

--
-- Role memberships
--

GRANT admin_requests TO web_authenticator GRANTED BY postgres;
GRANT web_requests TO web_authenticator GRANTED BY postgres;


--
-- PostgreSQL database cluster dump complete
--
