﻿CREATE DATABASE "TISI"
TEMPLATE = TEMPLATE0
ENCODING 'WIN1252'
CONNECTION LIMIT -1;

----------------------------------- TB_EMPRESA -----------------------------------
CREATE TABLE TB_EMPRESA(
	ID_EMPRESA SERIAL,
	RAZAO_SOCIAL VARCHAR(60),
	NOME_FANTASIA VARCHAR(60),
	CNPJ VARCHAR(18),
	EMAIL VARCHAR(40),
	SENHA VARCHAR(50),
	TELEFONE VARCHAR(20),
	RUA VARCHAR(40),
	NUMERO INTEGER,
	BAIRRO VARCHAR(40),
	CEP VARCHAR(15),
	CIDADE VARCHAR(60),
	ESTADO VARCHAR(40),
	FG_ATIVO INTEGER,
	CONSTRAINT PK_TB_EMPRESA_ID_EMPRESA PRIMARY KEY(ID_EMPRESA)
);
--

----------------------------------- TB_CUSTO -----------------------------------
CREATE TABLE TB_CUSTO(
	ID_CUSTO SERIAL,
	VALOR_TECIDO NUMERIC(7,2),
	VALOR_ESPUMA NUMERIC(7,2),
constraint pk_tb_custo_id_custo PRIMARY KEY(ID_CUSTO)
);

select * from tb_custo

----------------------------------- TB_Novo -----------------------------------
CREATE TABLE TB_NOVO(
	ID_NOVO SERIAL , 
	DT_NOVO DATE, 
	PRODUTO_NOVO VARCHAR(60), 
	QUANTIDADE_NOVO INTEGER, 
	NUMERO_NOVO INTEGER,
	COR	VARCHAR(30)
constraint pk_tb_novo_id_novo PRIMARY KEY(ID_NOVO)
);

select * from tb_novo 
delete from tb_novo where numero_novo=3

SELECT ID_NOVO, DT_NOVO, PRODUTO_NOVO, QUANTIDADE_NOVO, NUMERO_NOVO, COR
FROM TB_NOVO 
ORDER BY ID_NOVO;

SELECT COR,
	TOTAL, 
	TOTAL_PLACAS, 
	TOTAL_PLACAS*1.2 AS VALOR_ESPUMA, 
	TOTAL_PLACAS*0.4 AS VALOR_TECIDO, 
	ROUND(TOTAL_PLACAS*1.2 * (SELECT VALOR_ESPUMA FROM TB_CUSTO), 4) AS CUSTO_ESPUMA,
	ROUND(TOTAL_PLACAS*0.4 * (SELECT VALOR_TECIDO FROM TB_CUSTO), 4) AS CUSTO_TECIDO
FROM (
	SELECT COR, TOTAL, ROUND(((TOTAL_MARGEM - MOD(TOTAL_MARGEM, 8)) / 8 + 1), 0) AS TOTAL_PLACAS
	FROM (
		SELECT COR, TOTAL, (TOTAL*1.1) AS TOTAL_MARGEM
		FROM (
			SELECT COR, SUM(CAST(QUANTIDADE_NOVO AS NUMERIC)) AS TOTAL
			FROM TB_NOVO
			GROUP BY COR
		) AS PEDIDO
	) AS PLACAS
) AS CUSTO;

----------------------------------- TB_PEDIDO -----------------------------------

CREATE TABLE TB_PEDIDO(
	ID_PEDIDO SERIAL,
	ID_NOVO INTEGER,
CONSTRAINT pk_tb_pedido PRIMARY KEY (ID_PEDIDO),
CONSTRAINT fk_tb_pedido_novo_id_novo FOREIGN KEY (ID_NOVO)
	REFERENCES TB_NOVO(ID_NOVO)
);

select * FROM tb_pedido

SELECT P.ID_PEDIDO, N.ID_NOVO, N.DT_NOVO, N.PRODUTO_NOVO, N.QUANTIDADE_NOVO, N.NUMERO_NOVO
FROM TB_PEDIDO P
INNER JOIN TB_NOVO N ON N.ID_NOVO = P.ID_PEDIDO
ORDER BY P.ID_PEDIDO;





----------------------------------- TB_MATERIA PRIMA -----------------------------------
CREATE TABLE TB_MP(
	ID_MP Serial,
	ID_PEDIDO INTEGER,
	ID_NOVO INTEGER,
CONSTRAINT pk_tb_mp_id_mp PRIMARY KEY (ID_MP),
CONSTRAINT fk_tb_mp_novo_id_pedido FOREIGN KEY (ID_PEDIDO)
	REFERENCES TB_PEDIDO(ID_PEDIDO),
CONSTRAINT fk_tb_mp_novo_id_novo FOREIGN KEY (ID_NOVO)
	REFERENCES TB_NOVO(ID_NOVO)
);
drop table tb_mp
select * FROM tb_mp

SELECT ID_MP, NOME_MP, VALOR_MP, TOTAL_MP, VERBA_MP, CUSTO_MP 
FROM TB_MP
WHERE ID_MP >=1;



SELECT MP.ID_MP ,P.ID_PEDIDO , N.ID_NOVO ,NOME_MP , N.COR , N.QUANTIDADE_NOVO , VALOR_MP, TOTAL_MP,VERBA_MP,CUSTO_MP 
FROM TB_PEDIDO P
INNER JOIN TB_NOVO N ON N.ID_NOVO = P.ID_PEDIDO
INNER JOIN TB_MP MP ON MP.ID_MP = N.ID_NOVO
ORDER BY MP.ID_MP;

SELECT ID_CUSTO, VALOR_TECIDO, VALOR_ESPUMA 
FROM TB_CUSTO;

----------------------------------- TB_MATERIA PRIMA_CUSTO -----------------------------------
/*CREATE TABLE TB_MP_CUSTO(
	ID_MP INTEGER,
	VALOR_MP NUMERIC(7,2),
CONSTRAINT fk_tb_mp_custo_id_mp FOREIGN KEY(ID_MP)
	REFERENCES TB_MP(ID_MP)
);
drop table tb_mp_custo
select * FROM tb_mp_custo*/