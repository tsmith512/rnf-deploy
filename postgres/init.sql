--
-- PostgreSQL database cluster dump
--

-- @TODO: INITIAL POC OF THIS FILE HAD PASSWORDS IN IT, PULL AND ROTATE

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
ALTER ROLE rnf WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5eca13f59b80b93830d25faa3283d9faa';
CREATE ROLE web_authenticator;
ALTER ROLE web_authenticator WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md54c7ccdefa5d7e8c46b7aa4c291d1c1ee';
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

-- Set the PostgREST secret

ALTER ROLE web_authenticator SET pgrst.jwt_secret = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYWRtaW5fcmVxdWVzdHMifQ.ojpgP_ESFuS7oP9gAOexlSqcNohrBRuF59znxiB9tys";
