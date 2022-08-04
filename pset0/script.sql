CREATE ROLE administrator WITH
	LOGIN
	NOSUPERUSER
	CREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1
	PASSWORD '123456';
COMMENT ON ROLE administrator IS 'Administrador do banco de dados.';

CREATE DATABASE "animesDB"
    WITH
    OWNER = administrator
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE "animesDB"
    IS 'Banco de dados referente ao pset0 da matéria de Banco de Dados II.
';

\c animesDB administrator localhost 5432

CREATE SCHEMA IF NOT EXISTS animes
    AUTHORIZATION "administrator";

ALTER USER "administrator"
SET SEARCH_PATH TO animes, "\user", public;

