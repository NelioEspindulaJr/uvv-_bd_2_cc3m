/*
** CRIAR TABELA ALUNOS
** a) CHAVE PRIMÁRIA É UM CÓDIGO NUMÉRICO CRIADO POR UMA SEQUENCE
** b) EXISTA UM CAMP QUE, SE ESTIVER COM 'S', NENHUMA ALTERAÇAO PODE SER FEITA NOS DADOS E NEM REMOÇÃO
*/

DROP TABLE   students;

CREATE TABLE students (
    studentId              number(10)            NOT NULL,
    studentName            VARCHAR2(50)          NOT NULL,
    secured                CHAR(1)               NOT NULL,
    
    CONSTRAINT             students_pk           PRIMARY KEY (studentId),
    CONSTRAINT             students_ck_secured   CHECK (secured IN ('S','U')) -- ESSA CONSTRAINT IDENTIFICA 'S' COMO SECURED E 'U' COMO UNPROTECTED
);

/*
** CRIE UMA SEQUENCE PARA PIPULAR O CÓDIGO NUMÉRICO
** DA TABELA ALUNOS. ISSO SERÁ FEITO VIA TRIGGER
*/

DROP SEQUENCE       students_id_seq;

CREATE SEQUENCE     students_id_seq
    MINVALUE             1
    MAXVALUE        999999
    START WITH           1
    INCREMENT BY         1
    NOCACHE              ;
    
CREATE OR REPLACE TRIGGER students_bf_ins_trg
BEFORE INSERT ON students  
FOR EACH ROW 
BEGIN
   :new.studentId  :=  students_id_seq.NEXTVAL;
END;
/

-- INSERINDO DOIS ESTUDANTES, UM UNPROTECTED E OUTRO SECURED:
INSERT INTO students (studentName, secured) VALUES ('Nélio Junior', 'U');

INSERT INTO students (studentName, secured) VALUES ('Abrantes Silva', 'S');

COMMIT;

/*
** CRIAR TABELA USUÁRIOS COM UM CAMPO QUE INDIQUE SE O USUÁRIO É 'COMUM' OU 'ADMINISTRADOR'
** a) CHAVE PRIMÁRIA É O USERNAME DO USUÁRIO COM SESSÃO ATIVA
** b) CAMPO DE PERMISSIONAMENTO, 'C' PARA COMUM E 'A' PARA ADMINISTRADOR
*/

DROP TABLE   users;

CREATE TABLE users (
    username        VARCHAR2(50)          NOT NULL,
    permission      CHAR(1)               NOT NULL,
    
    CONSTRAINT      users_pk              PRIMARY KEY (username),
    CONSTRAINT      userts_ck_permission  CHECK (permission IN ('C','A')) -- ESSA CONSTRAINT IDENTIFICA 'A' COMO ADMINISTRATOR E 'C' COMO COMMON
);

-- INSERINDO DOIS USUÁRIOS, UM ADMINISTRATOR E OUTRO COMMON
INSERT INTO users (username, permission) VALUES ('hr', 'A');

INSERT INTO users (username, permission) VALUES ('common', 'C');

COMMIT;
/*
** CRIAR TRIGGERS QUE FAÇAM:
** a) SE USUÁRIO COMUM, ELE NÃO PODE ALTERAR NEM APAGAR CADASTROS DE AUNOS FINALIZADOS (secured = "S")
** b) SE O USÁRIO FOR ADMINISTRADOR, ELE PODE ALTERAR MAS NAO PODE APAGAR O CADASTRO DO ALUNO
*/

CREATE OR REPLACE TRIGGER students_bf_upd_del_trg 
BEFORE UPDATE OR DELETE ON students
FOR EACH ROW
DECLARE
        active_session  VARCHAR2(50);
BEGIN
    SELECT 
        permission
    INTO 
        active_session 
    FROM 
        users 
    WHERE 
        username = USER;

    IF active_session = 'C' AND :old.secured = 'S' THEN
        dbms_output.put_line('You do not have permission to alter or update students table.');
    ELSIF active_session = 'A' AND :old.secured = 'S' AND DELETING THEN
        dbms_output.put_line('You cannot delete a student!');
    END IF;
END;

select * from students;

Delete FROM students where studentId = 1;
