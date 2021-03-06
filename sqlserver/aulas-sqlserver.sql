/* OBS: NUMERO DA AULA BASEADA NA 3A VERSÃO DO CURSO */

/* banco de dados de sistema - aula 94 */

/* criando um banco de dados - aula 95 */

/* assunto - delimitador - clausula GO */

create database aula_sql

use aula_sql

create table teste(
	nome varchar(30)
)

-- quebrando para sincronizar os comandos com go
create database BANCO01
go

use BANCO01
go

create table teste(
	nome varchar(30)
)
go

/* arquitetura do sql server - aula 96 */

/* recomendado:
	um hd do systema operacional
	outro para o sql
	outro para os bancos de dados
*/

/* LDF e MDF */

/*	MDF - master data file -> dados
	LDF - log data file -> logs

	recomendacao da ms:
	MDF somente para o dicionario de dados

	criar um novo tipo de arquivo normalmente
	NDF - para os dados -> este pode ser separados em grupos e por conseguinte
		fisicamente em hd's diferentes.
		ex: um ou mais arquivos ndf pertencem ao grupo do departamento de marketing,
			outros ndf pertencem ao grupo do departamento de rh,
			outros pertencem ao grupo do departamento de vendas, etc.
*/

/* deletando alguns bancos */

drop database aula_sql
go

drop database BANCO01
go

/* particionando fisicamente um banco de dados - aula 97 */

/* organizar fisicamente e logicamente um banco de dados

1 - criar o banco com arquivos para os setores de MKT e VENDAS

2 - criar um arquivo geral para os outros

3 - deixar o MDF apenas com o dicionario de dados

4 - criar 2 grupos de arquivos (PRIMARY - MDF)

*/

/* passo a passo - no sql server manager studio

novo banco
	nome do banco EMPRESA
	grupo de arquivos
		já tem o PRIMARY
		adicionar grupo de arquivos
			GA_MARKETING
		adicionar grupo de arquivos
			GA_VENDAS
		adicionar grupo de arquivos
			GA_GERAL
		marcar o GA_GERAL como padrao -> criara os arquivos aqui quando nao apontado
	geral
		adicionar
			nome lógico: MARKETING
			nome do arquivo: MARKETING.ndf
			grupo de arquivos: GA_MARKETING
		adicionar
			nome lógico: VENDAS
			nome do arquivo: VENDAS.ndf
			grupo de arquivos: GA_VENDAS
		adicionar
			nome lógico: GERAL
			nome do arquivo: GERAL.ndf
			grupo de arquivos: já selecionado GA_GERAL
			aumento automatico: em 10MB, ilimitado
	ok

*/

/* criar tabelas no modo grafico - sql server manager studio */

/*

abrir pasta EMPRESA
	selecionar pasta Tabelas
		botao direito Tabela...
			nome da coluna: id
			tipo de dados: int
			permitir nulos: marcar
			nome da coluna: nome
			tipo de dados: varchar(50)
			permitir nulos: marcar
			aba propriedades
				nome: TB_MKT
				especificao de espaco de dados regular
					nome do esquema de particao ou grupo de arquivos: GA_MARKETING
				grupo de arquivos de texto/imagem: manter no GA_GERAL

	selecionar pasta Tabelas
		botao direito Tabela...
			nome da coluna: id
			tipo de dados: int
			permitir nulos: marcar
			nome da coluna: nome
			tipo de dados: varchar(50)
			permitir nulos: marcar
			aba propriedades
				nome: TB_VENDAS
				especificao de espaco de dados regular
					nome do esquema de particao ou grupo de arquivos: GA_VENDAS
				grupo de arquivos de texto/imagem: manter no GA_GERAL

menu Salvar

*/

create table TB_EMPRESA(
	ID INT,
	NOME VARCHAR(50)
)
go
-- esta tabela criada vai para o grupo GA_GERAL para verificar
-- clicar na tabela botao direito Design...

/* aula 98 */

/* linux sqlcmd */
sqlcmd -S localhost -U SA

<senha>

/* rodar script */

sqlcmd -S localhost -U SA -P senha -i /home/rodolfo/Documentos/aula.sql -o /home/rodolfo/Documentos/saida.txt
-- conectando a um banco

USE EMPRESA
GO

/* CRIACAO DE TABELAS */

CREATE TABLE ALUNO(
	IDALUNO INT PRIMARY KEY IDENTITY(1,1), -- COMECA EM 1 E INCREMENTA DE 1 EM 1.
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL,
	NASCIMENTO DATE NOT NULL,
	EMAIL VARCHAR(30) UNIQUE
)
GO
-- AS CHAVES FICAM COM NOMES ESTRANHOS NÃO FÁCEIS DE IDENTIFICACAO

-- CONSTRAINTS

ALTER TABLE ALUNO
ADD CONSTRAINT CK_SEXO CHECK (SEXO IN('M','F'))
GO
-- NO STUDIO CRIARÁ NA PASTA Restrições DENTRO DO FileTables um CK_SEXO

/* 1 X 1 */

CREATE TABLE ENDERECO(
	IDENDERECO INT PRIMARY KEY IDENTITY(100,10),
	BAIRRO VARCHAR(30),
	UF CHAR(2) NOT NULL
	CHECK (UF IN('RJ','SP','MG','ES')),
	ID_ALUNO INT UNIQUE
)
GO

-- CRIANDO A FK
ALTER TABLE ENDERECO ADD CONSTRAINT FK_ENDERECO_ALUNO
FOREIGN KEY (ID_ALUNO) REFERENCES ALUNO(IDALUNO)
GO

/* COMANDOS DE DESCRICAO */

DESC XYZ; SHOW CREATE TABLE XYZ;
--MY SQL

-- SQL SERVER PROCEDURES - JA CRIADAS E ARMAZENADAS NO SISTEMA
-- COMECA COM: SP_ -> STORAGE PROCEDURE

SP_COLUMNS ALUNO
GO
-- EQUIVALENMTE AO DESC DO MYSQL MAIS COMPLETO

SP_HELP ALUNO
GO
-- TAMBEM FAZ ALGO SEMELHANTE MAS MAIS COMPLETO AINDA

/* INSERINDO DADOS */

INSERT INTO ALUNO VALUES('ANDRE','M','1981/12/09','ANDRE@IG.COM')
INSERT INTO ALUNO VALUES('ANA','F','1978/03/09','ANA@IG.COM')
INSERT INTO ALUNO VALUES('RUI','M','1951/07/09','RUI@IG.COM')
INSERT INTO ALUNO VALUES('JOAO','M','2002/11/09','JOAO@IG.COM')
GO

SELECT * FROM ALUNO
GO

/* IFNULL - aula 99 */

INSERT INTO ENDERECO VALUES('FLAMENGO','RJ',1)
INSERT INTO ENDERECO VALUES('MORUMBI','SP',2)
INSERT INTO ENDERECO VALUES('CENTRO','MG',3)
INSERT INTO ENDERECO VALUES('CENTRO','SP',4)
GO

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) NOT NULL,
	NUMERO VARCHAR(15) NOT NULL,
	ID_ALUNO INT,
	CHECK (TIPO IN('CEL','RES','COM'))
)
GO

INSERT INTO TELEFONE VALUES('CEL','7899889',1)
INSERT INTO TELEFONE VALUES('RES','4325444',1)
INSERT INTO TELEFONE VALUES('COM','4354354',2)
INSERT INTO TELEFONE VALUES('CEL','2344556',2)
GO

SELECT * FROM ALUNO
GO

/* PEGAR DATA ATUAL */

SELECT GETDATE()
GO

/* CLAUSULA AMBIGUA */

SELECT A.NOME, T.TIPO, T.NUMERO, E.BAIRRO, E.UF
FROM ALUNO A
INNER JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

SELECT A.NOME, T.TIPO, T.NUMERO, E.BAIRRO, E.UF
FROM ALUNO A
LEFT JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

/* IFNULL */

SELECT 	A.NOME,
		ISNULL(T.TIPO,'SEM') AS TIPO,
		ISNULL(T.NUMERO,'NUMERO') AS NUMERO,
		E.BAIRRO, 
		E.UF
FROM ALUNO A
LEFT JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

/* DATAS */

SELECT * FROM ALUNO
GO

SELECT NOME, NASCIMENTO
FROM ALUNO
GO

/* DATEDIFF - CALCULA DIFERENCA ENTRE DUAS DATAS */

SELECT NOME, GETDATE() AS DIA_HORA FROM ALUNO
GO

SELECT NOME, DATEDIFF(DAY,NASCIMENTO,GETDATE()) AS 'IDADE'
FROM ALUNO
GO

SELECT  NOME, (DATEDIFF(DAY,NASCIMENTO,GETDATE())/365) AS 'IDADE'
FROM ALUNO
GO

SELECT  NOME, (DATEDIFF(MONTH,NASCIMENTO,GETDATE())/12) AS 'IDADE'
FROM ALUNO
GO

SELECT NOME, DATEDIFF(YEAR,NASCIMENTO,GETDATE()) AS 'IDADE'
FROM ALUNO
GO

/* DATENAME - TRAZ O NOME DA PARTE DA DATA EM QUESTAO (NOME = STRING)*/

SELECT NOME, DATENAME(MONTH,NASCIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(YEAR,NASCIMENTO)
FROM ALUNO
GO

SELECT NOME, DATENAME(WEEKDAY,NASCIMENTO)
FROM ALUNO
GO

/* DATEPART - IGUAL O DATENAME MAS RETORNA UM INTEIRO */

SELECT NOME, DATEPART(MONTH,NASCIMENTO)
FROM ALUNO
GO

SELECT NOME, DATEPART(MONTH,NASCIMENTO), DATENAME(MONTH,NASCIMENTO)
FROM ALUNO
GO

/* DATEADD - RETORNA DATA SOMANDO OUTRA DATA */

SELECT DATEADD(DAY,365,GETDATE())
GO

SELECT DATEADD(YEAR,10,GETDATE())
GO

/* CONVERSAO DE DADOS AULA 101 E 102 */

SELECT 1 + '1'
GO

SELECT '1' + '1'
GO

SELECT 'CURSO DE BANCO DE DADOS' + '1'
GO

SELECT 'CURSO DE BANCO DE DADOS' + 1
GO

/* FUNCOES DE CONVERSAO DE DADOS */

SELECT CAST('1' AS INT) + CAST('1' AS INT)
GO

/* CONVERSAO E CONCATENACAO
https://docs.microsoft.com/pt-br/sql/t-sql/data-types/data-type-conversion-database-engine?view=sql-server-ver15
*/

SELECT 	NOME,
		NASCIMENTO
FROM ALUNO
GO

SELECT  NOME,
		DAY(NASCIMENTO) + '/' + MONTH(NASCIMENTO) + '/' + YEAR(NASCIMENTO)
FROM ALUNO
GO

SELECT  NOME,
		CAST(DAY(NASCIMENTO) AS VARCHAR) + '/' + 
		CAST(MONTH(NASCIMENTO) AS VARCHAR) + '/' + 
		CAST(YEAR(NASCIMENTO) AS VARCHAR) AS "NASCIMENTO"
FROM ALUNO
GO

/* CHARINDEX - RETORNA UM INTEIRO AULA 103
	CONTAGEM DEFAULT = 01
*/

SELECT NOME, CHARINDEX('A', NOME) AS 'INDICE'
FROM ALUNO
GO

SELECT NOME, CHARINDEX('A', NOME, 2) AS 'INDICE'
FROM ALUNO
GO

/* BULK INSERT - IMPORTACAO DE ARQUIVOS AULA 104 */
-- \t = TAB ; \n = ENTER

CREATE TABLE LANCAMENTO_CONTABIL(
	CONTA INT,
	VALOR INT,
	DEB_CRED CHAR(1)
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
GO

BULK INSERT LANCAMENTO_CONTABIL
FROM '/home/rodolfo/Documentos/CONTAS.txt'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR = '\n'
)
GO

SELECT * FROM LANCAMENTO_CONTABIL
GO

/* DESAFIO DO SALDO - AULA 105
QUERY QUE TRAGA O NUMERO DA CONTA E
SALDO DEVEDOR OU CREDOR */

SELECT  CONTA, VALOR, DEB_CRED,
CHARINDEX('D',DEB_CRED) AS "DEBITO",
CHARINDEX('C',DEB_CRED) AS "CREDITO",
CHARINDEX('C',DEB_CRED) * 2 -1 AS "MULTIPLICADOR"
FROM LANCAMENTO_CONTABIL
GO

SELECT 	CONTA, 
		SUM(VALOR * (CHARINDEX('C',DEB_CRED) * 2 -1)) AS SALDO
FROM LANCAMENTO_CONTABIL
GROUP BY CONTA
ORDER BY CONTA
GO

/* TRIGGER DE DML - AULA 106 107 */

--CENÁRIO

USE EMPRESA
GO

CREATE TABLE PRODUTOS(
	IDPRODUTO INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECO NUMERIC(10,2) NOT NULL
)
GO

CREATE TABLE HISTORICO(
	IDOPERACAO INT PRIMARY KEY IDENTITY,
	PRODUTO VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECOANTIGO NUMERIC(10,2) NOT NULL,
	PRECONOVO NUMERIC(10,2) NOT NULL,
	DATA DATETIME,
	USUARIO VARCHAR(30),
	MENSAGEM VARCHAR(100)
)
GO

INSERT INTO PRODUTOS VALUES('LIVRO SQL SERVER', 'LIVROS', 98.00)
INSERT INTO PRODUTOS VALUES('LIVRO ORACLE', 'LIVROS', 50.00)
INSERT INTO PRODUTOS VALUES('LICENÇA POWERCENTER', 'SOFTWARES', 45000.00)
INSERT INTO PRODUTOS VALUES('NOTEBOOK I7', 'COMPUTADORES', 3150.00)
INSERT INTO PRODUTOS VALUES('LIVRO BUSINNES INTELIGENCE', 'LIVROS', 90.00)
GO

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO 
GO

/* VERIFICANDO O USUARIO */

SELECT SUSER_NAME()
GO

/* TRIGGER DE DADOS - DATA MANUPULATION LANGUAGE */

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE
AS
	DECLARE @IDPRODUTO INT
	DECLARE @PRODUTO VARCHAR(50)
	DECLARE @CATEGORIA VARCHAR(30)
	DECLARE @PRECO NUMERIC(10,2)
	DECLARE @PRECONOVO NUMERIC(10,2)
	DECLARE @DATA DATETIME
	DECLARE @USUARIO VARCHAR(30)
	DECLARE @ACAO VARCHAR(100)

	-- PRIMEIRO BLOCO
	SELECT @IDPRODUTO = IDPRODUTO FROM INSERTED
	SELECT @PRODUTO = NOME FROM INSERTED
	SELECT @CATEGORIA = CATEGORIA FROM INSERTED
	SELECT @PRECO = PRECO FROM DELETED
	SELECT @PRECONOVO = PRECO FROM INSERTED

	-- SEGUNDO BLOCO
	SET @DATA = GETDATE()
	SET @USUARIO = SUSER_NAME()
	SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'

	INSERT INTO HISTORICO
	(PRODUTO,CATEGORIA,PRECOANTIGO,PRECONOVO,DATA,USUARIO,MENSAGEM)
	VALUES
	(@PRODUTO,@CATEGORIA,@PRECO,@PRECONOVO,@DATA,@USUARIO,@ACAO)

	PRINT 'TRIGGER EXECUTADA COM SUCESSO'

GO

/* EXECUTANDO UM UPDATE */

UPDATE PRODUTO
SET PRECO = 100.00
WHERE IDPRODUTO = 1
GO

SELECT * FROM PRODUTOS
GO

SELECT * FROM HISTORICO
GO

UPDATE PRODUTOS SET NOME = 'LIVRO C#'
WHERE IDPRODUTO = 1
GO
-- TRIGGER FUNCIONA AQUI TAMBEM O QUE NÃO QUERIAMOS

/* PROGRAMANDO TRIGGER EM UMA COLUNA */

DROP TRIGGER TRG_ATUALIZA_PRECO
GO

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE AS
IF UPDATE (PRECO) -- TSQL - TRANSACTIONAL SQL LANGUAGE
BEGIN

	DECLARE @IDPRODUTO INT
	DECLARE @PRODUTO VARCHAR(50)
	DECLARE @CATEGORIA VARCHAR(30)
	DECLARE @PRECO NUMERIC(10,2)
	DECLARE @PRECONOVO NUMERIC(10,2)
	DECLARE @DATA DATETIME
	DECLARE @USUARIO VARCHAR(30)
	DECLARE @ACAO VARCHAR(100)

	-- PRIMEIRO BLOCO
	SELECT @IDPRODUTO = IDPRODUTO FROM INSERTED
	SELECT @PRODUTO = NOME FROM INSERTED
	SELECT @CATEGORIA = CATEGORIA FROM INSERTED
	SELECT @PRECO = PRECO FROM DELETED
	SELECT @PRECONOVO = PRECO FROM INSERTED

	-- SEGUNDO BLOCO
	SET @DATA = GETDATE()
	SET @USUARIO = SUSER_NAME()
	SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'

	INSERT INTO HISTORICO
	(PRODUTO,CATEGORIA,PRECOANTIGO,PRECONOVO,DATA,USUARIO,MENSAGEM)
	VALUES
	(@PRODUTO,@CATEGORIA,@PRECO,@PRECONOVO,@DATA,@USUARIO,@ACAO)

	PRINT 'TRIGGER EXECUTADA COM SUCESSO'

END
GO

UPDATE PRODUTOS SET PRECO = 300.00
WHERE IDPRODUTO = 2
GO 

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO
GO

UPDATE PRODUTOS SET NOME = 'LIVRO JAVA'
WHERE IDPRODUTO = 2
GO
-- OK TRIGGER NÃO PEGA MAIS ESTE TIPO DE OPERACAO

/* VARIAVEIS COM SELECT - AULA 108 */

SELECT 10 + 10
GO

CREATE TABLE RESULTADO(
	IDRESULTADO INT PRIMARY KEY IDENTITY,
	RESULTADO INT
)
GO

INSERT INTO RESULTADO VALUES((SELECT 10 + 10))
GO

SELECT * FROM RESULTADO
GO

/* ATRIBUINDO SELECTS A VARIAVEIS */

DECLARE
	@RESULTADO INT
	SET @RESULTADO = (SELECT 50 + 50)
	INSERT INTO RESULTADO VALUES(@RESULTADO)
	PRINT 'VALOR INSERIDO NA TABELA: ' + CAST(@RESULTADO AS VARCHAR)
GO

/* TRIGGER UPDATE */

CREATE TABLE EMPREGADO(
	IDEMPREGADO INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30),
	SALARIO MONEY,
	IDGERENTE INT
)
GO

ALTER TABLE EMPREGADO ADD CONSTRAINT FK_GERENTE
FOREIGN KEY (IDGERENTE) REFERENCES EMPREGADO(IDEMPREGADO)
GO

INSERT INTO EMPREGADO VALUES('CLARA',5000.00,NULL);
INSERT INTO EMPREGADO VALUES('CELIA',4000.00,1);
INSERT INTO EMPREGADO VALUES('JOAO',4000.00,1);
GO

SELECT * FROM EMPREGADO
GO

CREATE TABLE HIST_SALARIO(
	IDEMPREGADO INT,
	ANTIGOSAL MONEY,
	NOVOSAL MONEY,
	DATA DATETIME
)
GO

CREATE TRIGGER TGR_SALARIO
ON DBO.EMPREGADO
FOR UPDATE AS
IF UPDATE(SALARIO)
BEGIN
	INSERT INTO HIST_SALARIO
	(IDEMPREGADO, ANTIGOSAL, NOVOSAL, DATA)
	SELECT D.IDEMPREGADO, D.SALARIO, I.SALARIO, GETDATE()
	FROM DELETED D, INSERTED I
	WHERE D.IDEMPREGADO = I.IDEMPREGADO 
END
GO

UPDATE EMPREGADO SET SALARIO = SALARIO * 1.1
GO

SELECT * FROM HIST_SALARIO
GO

/* QUERY SALARIO ANTIGO, SALARIO NOVO, DATA, NOME DO EMPREGADO */

SELECT H.ANTIGOSAL, H.NOVOSAL, H.DATA, E.NOME
FROM HIST_SALARIO H
INNER JOIN EMPREGADO E
ON H.IDEMPREGADO = E.IDEMPREGADO 
GO

/* AULA 109 */

CREATE TABLE SALARIO_RANGE(
	MINSAL MONEY,
	MAXSAL MONEY
)
GO

INSERT INTO SALARIO_RANGE VALUES(3000.00, 6000.00)
GO

SELECT * FROM SALARIO_RANGE
GO

CREATE TRIGGER TGR_RANGE
ON DBO.EMPREGADO
FOR INSERT, UPDATE
AS
	DECLARE
		@MINSAL MONEY,
		@MAXSAL MONEY,
		@ATUALSAL MONEY

	SELECT @MINSAL = MINSAL, @MAXSAL = MAXSAL FROM SALARIO_RANGE

	SELECT @ATUALSAL = I.SALARIO FROM INSERTED I

	IF(@ATUALSAL < @MINSAL)
	BEGIN
		RAISERROR('SALARIO MENOR QUE O PISO',16,1)
		ROLLBACK TRANSACTION
	END

	IF(@ATUALSAL > @MAXSAL)
	BEGIN
		RAISERROR('SALARIO MAIOR QUE O TETO',16,1)
		ROLLBACK TRANSACTION
	END
GO

UPDATE EMPREGADO SET SALARIO = 9000.00
WHERE IDEMPREGADO = 1
GO

SELECT * FROM EMPREGADO
GO

SELECT * FROM HIST_SALARIO
GO

UPDATE EMPREGADO SET SALARIO = 1000.00
WHERE IDEMPREGADO = 2
GO

/* VERIFICANDO O TEXTO DE UMA TRIGGER */

SP_HELPTEXT TGR_RANGE
GO

/* PROCEDURES - AULA 110 */

-- SP_ XXX  - STORAGE PROCEDURE

CREATE TABLE PESSOA(
	IDPESSOA INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL CHECK (SEXO IN('M','F')), --ENUM
	NASCIMENTO DATE NOT NULL
)
GO

CREATE TABLE TELEFONE(
	IDTELEFONE INT NOT NULL IDENTITY,
	TIPO CHAR(3) NOT NULL CHECK ( TIPO IN('CEL','COM')),
	NUMERO CHAR(10) NOT NULL,
	ID_PESSOA INT
)
GO

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE_PESSOA
FOREIGN KEY(ID_PESSOA) REFERENCES PESSOA(IDPESSOA)
ON DELETE CASCADE
GO

INSERT INTO PESSOA VALUES('ANTONIO','M','1981-02-13')
INSERT INTO PESSOA VALUES('DANIEL','M','1985-03-18')
INSERT INTO PESSOA VALUES('CLEIDE','F','1979-10-13')

INSERT INTO TELEFONE VALUES('CEL','9879008',1)
INSERT INTO TELEFONE VALUES('COM','8757909',1)
INSERT INTO TELEFONE VALUES('CEL','9875890',2)
INSERT INTO TELEFONE VALUES('CEL','9347689',2)
INSERT INTO TELEFONE VALUES('COM','2998689',3)
INSERT INTO TELEFONE VALUES('COM','2098978',2)
INSERT INTO TELEFONE VALUES('CEL','9008679',3)
GO

SELECT * FROM PESSOA
SELECT * FROM TELEFONE
GO

/* CRIANDO A PROCEDURE */

CREATE PROC SOMA
AS
	SELECT 10 + 10 AS SOMA
GO

/* EXECUCAO DA PROCEDURE */

SOMA

EXEC SOMA
GO

/* DINAMICAS - COM PARAMETROS */

CREATE PROC CONTA @NUM1 INT, @NUM2 INT
AS
	SELECT @NUM1 + @NUM2 AS RESULTADO
GO

EXEC CONTA 90, 78
GO

/* APAGANDO A PROCEDURE */

DROP PROC CONTA
GO

/* PROCEDURES EM TABELAS */

SELECT NOME, NUMERO
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
WHERE TIPO = 'CEL'
GO

/* TRAZER OS TELEFONES DE ACORDO COM O TIPO PASSADO */

CREATE PROC TELEFONES @TIPO CHAR(3)
AS
	SELECT NOME, NUMERO
	FROM PESSOA
	INNER JOIN TELEFONE
	ON IDPESSOA = ID_PESSOA
	WHERE TIPO = @TIPO
GO

EXEC TELEFONES 'COM'
GO

EXEC TELEFONES 'RES'
GO

/* PARAMENTROS DE OUTPUT */

SELECT TIPO, COUNT(*) AS QUANTIDADE
FROM TELEFONE
GROUP BY TIPO
GO

/* CRIANDO PROCEDURE COM PARAMETROS DE ENTRADA E SAIDA */ 

CREATE PROCEDURE GETTIPO @TIPO CHAR(3), @CONTADOR INT OUTPUT
AS
	SELECT @CONTADOR = COUNT(*)
	FROM TELEFONE
	WHERE TIPO = @TIPO

/* EXECUTANDO  A PROCEDURE */
/* TRANSACTION SQL -> LINGUAGEM QUE O SQL SERVER TRABALHA */

DECLARE @SAIDA INT
EXEC GETTIPO @TIPO = 'CEL', @CONTADOR = @SAIDA OUTPUT
SELECT @SAIDA
GO

DECLARE @SAIDA INT
EXEC GETTIPO 'CEL', @SAIDA OUTPUT -- É NECESSÁRIO O OUTPUT 
SELECT @SAIDA
GO

/* PROCEDURE DE REGRA DE NEGOCIOS - AULA 111 */

/* PROCEDURE DE CADASTRO */

INSERT INTO PESSOA VALUES('MAFRA','M','1981-02-13')
GO

SELECT @@IDENTITY --> GUARDA O ULTIMO IDENTITY INSERIDO NA SEÇÃO
GO

SELECT * FROM PESSOA
GO

CREATE PROC CADASTRO @NOME VARCHAR(30), @SEXO CHAR(1), @NASCIMENTO DATE,
	@TIPO CHAR(3), @NUMERO VARCHAR(10)
AS
	DECLARE @FK INT

	INSERT INTO PESSOA VALUES(@NOME, @SEXO, @NASCIMENTO) --> GEREI UM ID

	SET @FK = (SELECT IDPESSOA FROM PESSOA WHERE IDPESSOA = @@IDENTITY)

	INSERT INTO TELEFONE VALUES(@TIPO, @NUMERO, @FK)
GO

EXEC CADASTRO 'JORGE', 'M', '1981-01-01', 'CEL', '99874563'
GO

SELECT * FROM PESSOA
SELECT * FROM TELEFONE
GO

SELECT PESSOA.*, TELEFONE.*
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
GO

/* TSQL -> É UM BLOCO DE LINGUAGEM DE PROGRAMACAO - AULA 112 */

/* PROGRAMAS SÃO UNIDADES QUE PODEM SER CHAMADAS DE BLOCOS ANONIMOS.
	BLOCOS ANONIMOS NÃO RECEBEM NOME, POIS NÃO SÃO SALVOS NO BANCO.
	CRIAMOS BLOCOS ANONIMOS QUANDO IREMOS EXECUTA-LOS UMA SO VEZ OU
	TESTAR ALGO. */

/* BLOCO DE EXECUCAO */

BEGIN
	PRINT 'PRIMEIRO BLOCO'
END
GO

/* BLOCOS DE ATRIBUICAO DE VARIAVEIS */

DECLARE
	@CONTADOR INT
BEGIN
	SET @CONTADOR = 5
	PRINT @CONTADOR
END
GO

SELECT @CONTADOR --> ERRO: VARIAVEL NÃO DECLARADA
GO

/* NO SQL SERVER CADA COLUNA VARIAVEL LOCAL, EXPRESSAO E PARAMETRO TEM UM TIPO. */

/* CONCATENAÇÃO E CONVERSÃO */

DECLARE
	@V_NUMERO NUMERIC(10,2) = 100.52,
	@V_DATA DATETIME = '20170207'
BEGIN
	PRINT 'VALOR NUMERICO: ' + CAST(@V_NUMERO AS VARCHAR) --> MAIS COMUM
	PRINT 'VALOR NUMERICO: ' + CONVERT(VARCHAR, @V_NUMERO) --> USADO MAIS PARA DATAS
	PRINT 'VALOR DE DATA: ' + CAST(@v_DATA AS VARCHAR)
	PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA, 121) --> FORMATO AMERICANO
	PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA, 120)
	PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA, 105) --> FORMATO PT-BREND
GO

/* ATRIBUINDO RESULTADO A VARIAVEIS - AULA 113 */

CREATE TABLE CARROS(
	CARRO VARCHAR(20),
	FABRICANTE VARCHAR(30)
)
GO

INSERT INTO CARROS VALUES('KA','FORD')
INSERT INTO CARROS VALUES('FIESTA','FORD')
INSERT INTO CARROS VALUES('PRISMA','FORD')
INSERT INTO CARROS VALUES('CLIO','RENAULT')
INSERT INTO CARROS VALUES('SANDERO','RENAULT')
INSERT INTO CARROS VALUES('CHEVETE','CHEVROLET')
INSERT INTO CARROS VALUES('OMEGA','CHEVROLET')
INSERT INTO CARROS VALUES('PALIO','FIAT')
INSERT INTO CARROS VALUES('DOBLO','FIAT')
INSERT INTO CARROS VALUES('UNO','FIAT')
INSERT INTO CARROS VALUES('GOL','VOLKSWAGEN')
GO

DECLARE
	@V_CONT_FORD INT,
	@V_CONT_FIAT INT
BEGIN
	-- MÉTODO 1	- O SELECT PRECISA RETORNAR UMA SIMPLES COLUNA E UM SÓ RESULTADO
	SET @V_CONT_FORD = (SELECT COUNT(*) FROM CARROS WHERE FABRICANTE = 'FORD')

	PRINT 'QUANTIDADE FORD: ' + CAST(@V_CONT_FORD AS VARCHAR)

	-- MÉTODO 2
	SELECT @V_CONT_FIAT = COUNT(*) FROM CARROS WHERE FABRICANTE = 'FIAT'

	PRINT 'QUANTIDADE FIAT: ' + CONVERT(VARCHAR, @V_CONT_FIAT)
END
GO

/* BLOCOS IF E ELSE - AULA 114 */

DECLARE
	@NUMERO INT = 5
BEGIN
	IF @NUMERO = 5 --> EXPRESSAO BOOLEANA
		PRINT 'O VALOR É VERDADEIRO'
	ELSE
		PRINT 'O VALOR É FALSO'
END
GO

/* CASE */

DECLARE
	@CONTADOR INT
BEGIN
	SELECT
	CASE --> O CASE REPRESENTA UMA COLUNA
		WHEN FABRICANTE = 'FIAT' THEN 'FAIXA 1'
		WHEN FABRICANTE = 'CHEVROLET' THEN 'FAIXA 2'
		ELSE 'OUTRAS FAIXAS'
	END AS "INFORMACOES",
	*
	FROM CARROS
END
GO

-- CASE NÃO É TSQL VIDE ABAIXO
SELECT
CASE --> O CASE REPRESENTA UMA COLUNA
	WHEN FABRICANTE = 'FIAT' THEN 'FAIXA 1'
	WHEN FABRICANTE = 'CHEVROLET' THEN 'FAIXA 2'
	ELSE 'OUTRAS FAIXAS'
END AS "INFORMACOES",
*
FROM CARROS
GO
-- MAS PODE SER USADO EM BLOCO DE PROGRAMACAO
/* OBS: BLOCOS NOMEADOS SÃO AS PROCEDURES */

/* TRANSFORMANDO BLOCO NAO NOMEADO EM PROCEDURE */ 

CREATE PROC VERIFICA_NUM @NUMERO INT
AS
	BEGIN
		IF @NUMERO = 5 --> EXPRESSAO BOOLEANA
			PRINT 'O VALOR É VERDADEIRO'
		ELSE
			PRINT 'O VALOR É FALSO'
	END
GO

EXEC VERIFICA_NUM 5
GO

EXEC VERIFICA_NUM 4
GO

/* LOOPS - AULA 115 */
/* WHILE */

DECLARE
	@I INT = 1
BEGIN
	WHILE (@I < 15)
	BEGIN
		PRINT 'VALOR DE I = ' + CAST(@I AS VARCHAR)
		SET @I = @I + 1
	END
END
GO

/* FIM DE SQL SERVER */