/*
______________________________________________________________
|                         _________                           |
|                        | ATENÇÃO |                          |
|                         ‾‾‾‾‾‾‾‾‾                           |
|    SCRIPT PARA CRIAÇÃO DO BANCO DE DADOS DO PSET0.          |
|_____________________________________________________________|
| Alunos:                                                     |
| Turma: CC3M                                                 |
| Professor: Abrantes Araújo Silva Filho                      |                                                          
 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
*/

DROP ROLE IF EXISTS administrator;
DROP DATABASE IF EXISTS animesDB;
DROP SCHEMA IF EXISTS animes CASCADE;

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
    IS 'Banco de dados referente ao pset0 da matéria de Banco de Dados II.';

\c animesDB administrator

CREATE SCHEMA animes
    AUTHORIZATION "administrator";

ALTER USER "administrator"
SET SEARCH_PATH TO animes, "\user", public;


CREATE TABLE animes.anime (
                anime_id INTEGER NOT NULL,
                titulo VARCHAR(50) NOT NULL,
                autor_id INTEGER NOT NULL,
                tipo VARCHAR(10) NOT NULL,
                criador VARCHAR(30) NOT NULL,
                data_lancamento DATE NOT NULL,
                data_encerramento DATE,
                total_episodios INTEGER NOT NULL,
                avaliacao NUMERIC(5) NOT NULL,
                status VARCHAR(15) NOT NULL,
                estudio_id INTEGER NOT NULL,
                sinopse VARCHAR NOT NULL,
                CONSTRAINT pk_animes_id PRIMARY KEY (anime_id)
);
COMMENT ON TABLE animes.anime IS 'Essa tabela contém os dados referentes ao anime';
COMMENT ON COLUMN animes.anime.anime_id IS 'Primary Key da tabela Anime. Serve como identificador do anime.';
COMMENT ON COLUMN animes.anime.titulo IS 'Contém o título do anime.';
COMMENT ON COLUMN animes.anime.autor_id IS 'Foreign Key referente ao respectivo autor do anime.';
COMMENT ON COLUMN animes.anime.tipo IS 'Tipo do anime (Se é um OVA, série de TV ou filme)';
COMMENT ON COLUMN animes.anime.criador IS 'Nome do criador do anime';
COMMENT ON COLUMN animes.anime.data_lancamento IS 'Data de lançamento do Anime.';
COMMENT ON COLUMN animes.anime.data_encerramento IS 'Data de encerramento do anime. Campo pode ser nulo pois existem animes que ainda não encerraram';
COMMENT ON COLUMN animes.anime.total_episodios IS 'Quantidade total de episódios do anime lançados até o momento.';
COMMENT ON COLUMN animes.anime.avaliacao IS 'Nota geral das avaliações feitas por usuários que viram aquele anime';
COMMENT ON COLUMN animes.anime.status IS 'Status atual do anime em relação ao lançamento de episódios (se já finalizou, em lançamento, em hiato, etc)';
COMMENT ON COLUMN animes.anime.estudio_id IS 'Foreign Key referente ao estudio que produziu este anime.';
COMMENT ON COLUMN animes.anime.sinopse IS 'Sinopse que resume a história e o que se passa no anime.';

CREATE SEQUENCE animes.autores_autores_id_seq;

CREATE TABLE animes.autores (
                autores_id INTEGER NOT NULL DEFAULT nextval('animes.autores_autores_id_seq'),
                nome VARCHAR(50) NOT NULL,
                data_nascimento DATE NOT NULL,
                data_falecimento VARCHAR,
                sexo VARCHAR(1) NOT NULL,
                CONSTRAINT pk_autores_id PRIMARY KEY (autores_id)
);
COMMENT ON TABLE animes.autores IS 'Tabela que armazena autores/criadores de animes';
COMMENT ON COLUMN animes.autores.autores_id IS 'Código identificador do autor do anime.';
COMMENT ON COLUMN animes.autores.nome IS 'Nome do autor';
COMMENT ON COLUMN animes.autores.data_nascimento IS 'Data de nascimento do autor.';
COMMENT ON COLUMN animes.autores.data_falecimento IS 'Data de falecimento do autor. Pode ser vazio pois o autor pode estar vivo';
COMMENT ON COLUMN animes.autores.sexo IS 'Gênero do autor. Com constraint para ser apenas ''F'' ou ''M''';

ALTER SEQUENCE animes.autores_autores_id_seq OWNED BY animes.autores.autores_id;

CREATE SEQUENCE animes.estudio_estudio_id_seq;

CREATE TABLE animes.estudio (
                estudio_id INTEGER NOT NULL DEFAULT nextval('animes.estudio_estudio_id_seq'),
                name VARCHAR(50) NOT NULL,
                CONSTRAINT pk_estudio_id PRIMARY KEY (estudio_id)
);
COMMENT ON COLUMN animes.estudio.estudio_id IS 'Código identificador do estudio';
COMMENT ON COLUMN animes.estudio.name IS 'Nome do estudio';


ALTER SEQUENCE animes.estudio_estudio_id_seq OWNED BY animes.estudio.estudio_id;



CREATE TABLE animes.personagens (
                personagens_id INTEGER NOT NULL,
                anime_id INTEGER NOT NULL,
                sexo VARCHAR(1) NOT NULL,
                nome VARCHAR(30) NOT NULL,
                CONSTRAINT pk_personagens_id PRIMARY KEY (personagens_id)
);
COMMENT ON TABLE animes.personagens IS 'Tabela que armazena as personagens principais dos animes.';
COMMENT ON COLUMN animes.personagens.personagens_id IS 'Código identificador do personagem';
COMMENT ON COLUMN animes.personagens.anime_id IS 'Foreign Key do ID do anime a qual este personagem pertence.';
COMMENT ON COLUMN animes.personagens.sexo IS 'Gênero do Personagem. Com constraint para ser apenas ''F'' ou ''M''.';
COMMENT ON COLUMN animes.personagens.nome IS 'Nome do Personagem.';


ALTER TABLE animes.anime ADD CONSTRAINT autores_anime_fk
FOREIGN KEY (autor_id)
REFERENCES animes.autores (autores_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE animes.anime ADD CONSTRAINT estudio_anime_fk
FOREIGN KEY (estudio_id)
REFERENCES animes.estudio (estudio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE animes.personagens ADD CONSTRAINT anime_personagens_fk
FOREIGN KEY (anime_id)
REFERENCES animes.anime (anime_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;