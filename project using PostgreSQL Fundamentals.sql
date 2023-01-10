
CREATE TABLE situacao(
	codigo integer primary key,
	nome varchar(50) CHECK (nome in ('Confirmada','Finalizada','Em Atraso'))
 );
 
 CREATE TABLE cliente(
	codigo integer primary key,
	nome varchar(100) not null,
	endereco varchar(100) not null,
	telefone numeric(11),
	dt_nascimento date not null,
	sexo char check (sexo = 'F' or sexo = 'M')
 );
 
 CREATE TABLE roupa (
	codigo integer primary key,
	tipo varchar(50) not null check (tipo in ('Vestido Noiva','Vestido Madrinha','Terno')),
	colecao  varchar(50) not null,
	tamanho integer not null,
	cor varchar(50) not null,
	valor numeric(10,2) not null
 );
 
 CREATE TABLE locacao(
	codigo integer primary key,
	dt_locacao date not null,
	qtd_dias integer not null,
	dt_entrega date,
	valor numeric(10,2) not null,
	cod_cliente integer not null,
	cod_roupa integer not null,
	cod_situacao integer not null,
	constraint fk_cli foreign key (cod_cliente) references cliente(codigo),
	constraint fk_rou foreign key (cod_roupa) references roupa(codigo),
	constraint fk_sta foreign key (cod_situacao)  references situacao(codigo)
 );
 
 --EX1
 CREATE SEQUENCE seq_sit;
 CREATE SEQUENCE seq_cli;
 CREATE SEQUENCE seq_rou;
 CREATE SEQUENCE seq_loc;
 
 --EX2
 INSERT INTO situacao VALUES (nextval('seq_sit'), 'Confirmada');
 INSERT INTO situacao VALUES (nextval('seq_sit'), 'Finalizada');
 
 INSERT INTO cliente VALUES (nextval('seq_cli'), 'Jorge', 'Rua Jardim Florida', 12997864090, '2004-02-02', 'M');
 INSERT INTO cliente VALUES (nextval('seq_cli'),'Marcos', 'Rua Jardim das Flores', 12981591367, '2004-02-07', 'M');
 
 INSERT INTO roupa VALUES (nextval('seq_rou'),'Vestido Noiva', 'Inverno', 48, 'Branco', 10000.00);
 INSERT INTO roupa VALUES (nextval('seq_rou'),'Vestido Madrinha', 'Outono', 50, 'Lilás', 7500.00);
 
 INSERT INTO locacao VALUES (nextval('seq_loc'),'2022-02-02', 10, '2022-10-06', 4500.00,
							(SELECT codigo FROM cliente WHERE nome='Jorge'),
							(SELECT codigo FROM roupa WHERE colecao='Inverno'),
							(SELECT codigo FROM situacao WHERE nome='Confirmada')
							);
 INSERT INTO locacao VALUES (nextval('seq_loc'),'2022-03-07', 10, '2022-06-09', 2000.00,
							(SELECT codigo FROM cliente WHERE nome='Marcos'),
							(SELECT codigo FROM roupa WHERE colecao='Outono'),
							(SELECT codigo FROM situacao WHERE nome='Finalizada')
							);
							
 --EX3
 CREATE INDEX idx_dt_locacao ON locacao (dt_locacao);
 CREATE INDEX idx_dt_entrega ON locacao (dt_entrega);
 --EX4
 CREATE VIEW locacoes_atraso AS (
 SELECT locacao.codigo, locacao.dt_locacao,
locacao.dt_entrega FROM locacao INNER JOIN 
	 situacao ON locacao.cod_situacao = situacao.codigo
	 WHERE situacao.nome='Em atraso' ORDER BY locacao.dt_locacao ASC
 );
 
 --EX5
 CREATE VIEW quantidade_locacoes AS (
 SELECT COUNT (*), r.tipo FROM 
	 locacao l, cliente c, roupa r
	 WHERE dt_locacao BETWEEN '2022-02-02' AND '2022-10-06' GROUP BY 
	 r.tipo ORDER BY r.tipo
 );
 
 --EX6
 CREATE VIEW pesquisa_locacoes AS (
 SELECT l.dt_locacao AS dt_locacao, c.nome AS nome_cliente, r.tipo AS tipo_roupa, s.nome AS situacao FROM locacao l
	 INNER JOIN cliente c ON l.cod_cliente = c.codigo
	 INNER JOIN roupa r ON l.cod_roupa = r.codigo
	 INNER JOIN situacao s ON l.cod_situacao = s.codigo
	 ORDER BY l.dt_locacao DESC, c.nome ASC
 );
 
 SELECT * FROM pesquisa_locacoes;
 