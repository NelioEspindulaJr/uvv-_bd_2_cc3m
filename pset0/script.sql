/*
______________________________________________________________
|                         _________                           |
|                        | ATENÇÃO |                          |
|                         ‾‾‾‾‾‾‾‾‾                           |
|    SCRIPT PARA CRIAÇÃO DO BANCO DE DADOS DO PSET0.          |
|_____________________________________________________________|
| Alunos: André Prado de Oliveira Clicia P. de Freitas,       |
| Ícaro Araújo Lucas Zanon e Nélio Espíndula Junior 		  |
| Turma: CC3M                                                 |
| Professor: Abrantes Araújo Silva Filho                      |                                                          
 ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
*/

DROP ROLE IF EXISTS administrator;
DROP DATABASE IF EXISTS animesDB;
DROP SCHEMA IF EXISTS animeProducao CASCADE;

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
    LC_COLLATE = 'pt-BR.UTF8'
    LC_CTYPE = 'pt-BR.UTF8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE "animesDB"
    IS 'Banco de dados referente ao pset0 da matéria de Banco de Dados II.';

\c animesDB administrator

CREATE SCHEMA animeProducao
    AUTHORIZATION "administrator";

ALTER USER "administrator"
SET SEARCH_PATH TO animes, "\user", public;



CREATE TABLE animeProducao.genero (
                genero_codigo INTEGER NOT NULL,
                genero_principal VARCHAR(50) NOT NULL,
                genero_secundario VARCHAR(50) NOT NULL,
                CONSTRAINT genero_pk PRIMARY KEY (genero_codigo)
);
COMMENT ON TABLE animeProducao.genero IS 'Tabela contendo os generos dos animes';
COMMENT ON COLUMN animeProducao.genero.genero_codigo IS 'Codigo de identificação da tabela genero. PK da tabela.';
COMMENT ON COLUMN animeProducao.genero.genero_principal IS 'Genero principal da obra.';
COMMENT ON COLUMN animeProducao.genero.genero_secundario IS 'Genero secundario do anime.';


CREATE TABLE animeProducao.personagens (
                codigo_personagem INTEGER NOT NULL,
                nome_personagem VARCHAR(50) NOT NULL,
                papel VARCHAR(13) NOT NULL,
                sexo VARCHAR(1) NOT NULL,
                CONSTRAINT personagens_pk PRIMARY KEY (codigo_personagem)
);
COMMENT ON TABLE animeProducao.personagens IS 'Tabela com as informações dos personagens.';
COMMENT ON COLUMN animeProducao.personagens.codigo_personagem IS 'Pk da tabela. Chave de identificação da tabela personagens.';
COMMENT ON COLUMN animeProducao.personagens.nome_personagem IS 'Nome do personagem.';
COMMENT ON COLUMN animeProducao.personagens.papel IS 'Diferencia personagens protagonistas de personagens suporte.';
COMMENT ON COLUMN animeProducao.personagens.sexo IS 'genero do personagem.';


CREATE TABLE animeProducao.animes (
                codigo_anime INTEGER NOT NULL,
                total_episodios INTEGER NOT NULL,
                obra_original VARCHAR(100) NOT NULL,
                data_lancamento DATE NOT NULL,
                media_nota INTEGER NOT NULL,
                genero_codigo INTEGER NOT NULL,
                nome VARCHAR(100) NOT NULL,
                codigo_personagem INTEGER NOT NULL,
                CONSTRAINT animes_pk PRIMARY KEY (codigo_anime)
);
COMMENT ON TABLE animeProducao.animes IS 'Tabela que salva as informações dos animes';
COMMENT ON COLUMN animeProducao.animes.codigo_anime IS 'PK da tabela animes. Codigo de identificação da tabela animes.';
COMMENT ON COLUMN animeProducao.animes.total_episodios IS 'Numero total de episódios do anime.';
COMMENT ON COLUMN animeProducao.animes.obra_original IS 'Material original do qual o anime foi adaptado.';
COMMENT ON COLUMN animeProducao.animes.data_lancamento IS 'Data de estréia do anime.';
COMMENT ON COLUMN animeProducao.animes.media_nota IS 'Nota media do anime de 0 a 10.';
COMMENT ON COLUMN animeProducao.animes.genero_codigo IS 'FK da tabela genero_id';
COMMENT ON COLUMN animeProducao.animes.nome IS 'Nome do anime.';
COMMENT ON COLUMN animeProducao.animes.codigo_personagem IS 'Pk da tabela. Chave de identificação da tabela personagens.';


CREATE TABLE animeProducao.produtora (
                NIF_produtora INTEGER NOT NULL,
                roteirista  VARCHAR(50),
                produtor VARCHAR(50),
                editor VARCHAR(50),
                nome_produtora VARCHAR(50) NOT NULL,
                CONSTRAINT produtora_pk PRIMARY KEY (NIF_produtora)
);
COMMENT ON TABLE animeProducao.produtora IS 'Tabela com os dados da produtora.';
COMMENT ON COLUMN animeProducao.produtora.NIF_produtora IS 'Numero de Identificação Fiscal. Pk da tabela produtora. O equivalente a um CNPJ brasileiro.';
COMMENT ON COLUMN animeProducao.produtora.roteirista  IS 'Nome do roteirista do anime.';
COMMENT ON COLUMN animeProducao.produtora.produtor IS 'Nome do produtor do anime.';
COMMENT ON COLUMN animeProducao.produtora.editor IS 'Nome do editor do anime.';
COMMENT ON COLUMN animeProducao.produtora.nome_produtora IS 'nome da produtora';


CREATE TABLE animeProducao.estudio (
                NIF_estudio INTEGER NOT NULL,
                designer VARCHAR(50) NOT NULL,
                diretor_de_storyboard VARCHAR(50) NOT NULL,
                diretor_de_animacao VARCHAR(50) NOT NULL,
                diretor_de_fotografia VARCHAR(50) NOT NULL,
                codigo_anime INTEGER NOT NULL,
                NIF_produtora INTEGER NOT NULL,
                nome_estudio VARCHAR(50) NOT NULL,
                CONSTRAINT estudio_pk PRIMARY KEY (NIF_estudio)
);
COMMENT ON TABLE animeProducao.estudio IS 'Tabela com os dados do estudio.';
COMMENT ON COLUMN animeProducao.estudio.NIF_estudio IS 'Numero de Identificação Fiscal. Pk da tabela estudio. O equivalente a um CNPJ brasileiro.';
COMMENT ON COLUMN animeProducao.estudio.designer IS 'Nome do designer do estudio.';
COMMENT ON COLUMN animeProducao.estudio.diretor_de_storyboard IS 'Nome do diretor de storyboard.';
COMMENT ON COLUMN animeProducao.estudio.diretor_de_animacao IS 'Nome do diretor de animação.';
COMMENT ON COLUMN animeProducao.estudio.diretor_de_fotografia IS 'Nome do diretor de fotografia.';
COMMENT ON COLUMN animeProducao.estudio.codigo_anime IS 'PK da tabela animes. Codigo de identificação da tabela animes.';
COMMENT ON COLUMN animeProducao.estudio.NIF_produtora IS 'Numero de Identificação Fiscal. Pk da tabela produtora. O equivalente a um CNPJ brasileiro.';
COMMENT ON COLUMN animeProducao.estudio.nome_estudio IS 'nome do estdio';


ALTER TABLE animeProducao.animes ADD CONSTRAINT genero_animes_fk
FOREIGN KEY (genero_codigo)
REFERENCES animeProducao.genero (genero_codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE animeProducao.animes ADD CONSTRAINT personagens_animes_fk
FOREIGN KEY (codigo_personagem)
REFERENCES animeProducao.personagens (codigo_personagem)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE animeProducao.estudio ADD CONSTRAINT animes_estudio_fk
FOREIGN KEY (codigo_anime)
REFERENCES animeProducao.animes (codigo_anime)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE animeProducao.estudio ADD CONSTRAINT produtora_estudio_fk
FOREIGN KEY (NIF_produtora)
REFERENCES animeProducao.produtora (NIF_produtora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
