/* EXERCICIO 4 */

/* PROJETO OFICINA DO SEU JOSÉ */

/*

1) Crie um banco de dados chamado projeto e conecte-se ao banco.

2) Faça a seguinte modelagem:

	Sr. José quer modernizar a sua oficina, e poe enquanto, cadastrar os carros que entram
	para realizar serviços e os seus respectivos donos. Sr. José mencionou que cada cliente
	possui apenas um carro. Um carro possui uma marca. Sr. José também quer saber as
	cores dos carros para ter idéia de qual tinta comprar, e informa que um carro pode ter
	mais de uma cor. Sr José necessita armazenar os telefones dos clientes, mas não quer
	que eles sejam obrigatórios.

*/

-- 1) USAREI OFICINA AO INVES DE PROJETO POIS ESTE JÁ EXISTE E NÃO QUERO APAGAR

CREATE DATABASE OFICINA;

USE OFICINA;

-- 2)

-- modelagem lógica no arquivo: oficina-modelagem.brM3

-- modelagem física:

CREATE TABLE CARRO(
	IDCARRO INT PRIMARY KEY AUTO_INCREMENT,
	MODELO VARCHAR(30) NOT NULL,
	PLACA VARCHAR(30) NOT NULL UNIQUE,
	ID_MARCA INT
);

CREATE TABLE CLIENTE(
	IDCLIENTE INT PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(30) NOT NULL,
	SEXO ENUM('F','M') NOT NULL,
	ID_CARRO INT UNIQUE
);

CREATE TABLE COR(
	IDCOR INT PRIMARY KEY AUTO_INCREMENT,
	COR VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE MARCA(
	IDMARCA INT PRIMARY KEY AUTO_INCREMENT,
	MARCA VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY AUTO_INCREMENT,
	TIPO ENUM('CEL','RES','COM') NOT NULL,
	NUMERO VARCHAR(15) NOT NULL,
	ID_CLIENTE INT
);

CREATE TABLE CARRO_COR(
	ID_CARRO INT,
	ID_COR INT,
	PRIMARY KEY(ID_CARRO,ID_COR)
);

/* CONSTRAINT */

ALTER TABLE CARRO 
ADD CONSTRAINT FK_CARRO_MARCA
FOREIGN KEY (ID_MARCA)
REFERENCES MARCA(IDMARCA);

ALTER TABLE CLIENTE 
ADD CONSTRAINT FK_CLIENTE_CARRO
FOREIGN KEY (ID_CARRO)
REFERENCES CARRO(IDCARRO);

ALTER TABLE TELEFONE 
ADD CONSTRAINT FK_TELEFONE_CLIENTE
FOREIGN KEY (ID_CLIENTE)
REFERENCES CLIENTE(IDCLIENTE);

ALTER TABLE CARRO_COR
ADD CONSTRAINT FK_CARRO
FOREIGN KEY (ID_CARRO)
REFERENCES CARRO(IDCARRO);

ALTER TABLE CARRO_COR
ADD CONSTRAINT FK_COR
FOREIGN KEY (ID_COR)
REFERENCES COR(IDCOR);

/* INSERCAO DE DADOS */

INSERT INTO MARCA VALUES (NULL, 'GM');
INSERT INTO CARRO VALUES (NULL, 'ONIX', 'ABC0A00', 1);

INSERT INTO MARCA VALUES (NULL, 'HYUMDAI');
INSERT INTO CARRO VALUES (NULL, 'HB20', 'BCD1B23', 2);

INSERT INTO MARCA VALUES (NULL, 'FIAT');
INSERT INTO CARRO VALUES (NULL, 'ARGO', 'CDE2C34', 3);

INSERT INTO MARCA VALUES (NULL, 'VW');
INSERT INTO CARRO VALUES (NULL, 'GOL', 'DEF3D45', 4);

INSERT INTO MARCA VALUES (NULL, 'FORD');
INSERT INTO CARRO VALUES (NULL, 'KA', 'EFG4E56', 5);

INSERT INTO MARCA VALUES (NULL, 'JEEP');
INSERT INTO CARRO VALUES (NULL, 'RENEGADE', 'FGH5F67', 6);

INSERT INTO CARRO VALUES (NULL, 'TRACKER', 'GHI6G78', 1);

INSERT INTO CARRO VALUES (NULL, 'COMPASS', 'HIJ7H89', 6);

INSERT INTO CARRO VALUES (NULL, 'MOBI', 'IJK8I90', 3);

INSERT INTO CARRO VALUES (NULL, 'T CROSS', 'JKL9J01', 4);

INSERT INTO CLIENTE VALUES (NULL, 'JOAO', 'M', 1);
INSERT INTO CLIENTE VALUES (NULL, 'MARIA', 'F', 2);
INSERT INTO CLIENTE VALUES (NULL, 'CARLOS', 'M', 3);
INSERT INTO CLIENTE VALUES (NULL, 'ANA', 'F', 4);
INSERT INTO CLIENTE VALUES (NULL, 'ADRIANO', 'M', 5);
INSERT INTO CLIENTE VALUES (NULL, 'CELIA', 'F', 6);
INSERT INTO CLIENTE VALUES (NULL, 'MARCOS', 'M', 7);
INSERT INTO CLIENTE VALUES (NULL, 'MARTA', 'F', 8);
INSERT INTO CLIENTE VALUES (NULL, 'MARCELO', 'M', 9);
INSERT INTO CLIENTE VALUES (NULL, 'JAQUELINE', 'F', 10);

INSERT INTO TELEFONE VALUES (NULL, 'CEL', '(11)98555-5555', 1);
INSERT INTO TELEFONE VALUES (NULL, 'CEL', '(11)97666-6666', 2);
INSERT INTO TELEFONE VALUES (NULL, 'RES', '(11)7655-5566', 2);
INSERT INTO TELEFONE VALUES (NULL, 'COM', '(11)6777-7777', 3);
INSERT INTO TELEFONE VALUES (NULL, 'CEL', '(11)96766-6677', 3);
INSERT INTO TELEFONE VALUES (NULL, 'RES', '(11)5888-8888', 4);

INSERT INTO TELEFONE VALUES (NULL, 'CEL', '(11)94999-9999', 6);
INSERT INTO TELEFONE VALUES (NULL, 'COM', '(11)3000-0000', 7);

INSERT INTO TELEFONE VALUES (NULL, 'CEL', '(13)92111-1111', 9);
INSERT INTO TELEFONE VALUES (NULL, 'RES', '(11)1444-4444', 10);
INSERT INTO TELEFONE VALUES (NULL, 'CEL', '(11)91433-3344', 10);

INSERT INTO COR VALUES(NULL, 'PRETO');
INSERT INTO COR VALUES(NULL, 'BRANCO');
INSERT INTO COR VALUES(NULL, 'VERMELHO');
INSERT INTO COR VALUES(NULL, 'PRATA');
INSERT INTO COR VALUES(NULL, 'CINZA');
INSERT INTO COR VALUES(NULL, 'AMARELO');
INSERT INTO COR VALUES(NULL, 'AZUL');
INSERT INTO COR VALUES(NULL, 'VERDE');
INSERT INTO COR VALUES(NULL, 'MARROM');

INSERT INTO CARRO_COR VALUES(1,2);
INSERT INTO CARRO_COR VALUES(2,3);
INSERT INTO CARRO_COR VALUES(3,5);
INSERT INTO CARRO_COR VALUES(4,4);
INSERT INTO CARRO_COR VALUES(5,7);
INSERT INTO CARRO_COR VALUES(6,6);
INSERT INTO CARRO_COR VALUES(7,9);
INSERT INTO CARRO_COR VALUES(8,1);
INSERT INTO CARRO_COR VALUES(9,2);
INSERT INTO CARRO_COR VALUES(10,1);
