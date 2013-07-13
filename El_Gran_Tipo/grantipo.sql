USE MASTER
GO
DROP DATABASE BD_GRANTIPO
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Creacion de base de datos BD_GRANTIPO
Fecha de creacion:	-- 10/04/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- Ninguno
Parametros:		-- Ninguno
*********************************************************************/
CREATE DATABASE BD_GRANTIPO
GO
USE BD_GRANTIPO
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Creacion de tabla dbo.GT_USER
Fecha de creacion:	-- 13/02/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- dbo.GT_USER
Parametros:		-- Ninguno
*********************************************************************/

CREATE TABLE dbo.GT_USER
(
sol_user	VARCHAR(10)	not null,
amo_user	VARCHAR(10)	not null,
dat_user	DATETIME	not null,
)
GO

ALTER TABLE dbo.GT_USER
ADD CONSTRAINT PKCODIGO_USER
PRIMARY KEY (sol_user,amo_user)
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Creacion de tabla dbo.GT_PRIZE
Fecha de creacion:	-- 13/02/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- dbo.GT_PRIZE
Parametros:		-- Ninguno
*********************************************************************/

CREATE TABLE dbo.GT_PRIZE
(
cod_prize		CHAR(4)		not null,
des_prize		VARCHAR(30)	not null,
amo_prize		MONEY		not null,
st_prize		INT		null,
)
GO

ALTER TABLE dbo.GT_PRIZE
ADD CONSTRAINT PKCODIGO_PRIZE
PRIMARY KEY (cod_prize)
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Creacion de tabla dbo.GT_WINNER
Fecha de creacion:	-- 13/02/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- dbo.GT_WINNER
Parametros:		-- Ninguno
*********************************************************************/

CREATE TABLE dbo.GT_WINNER
(
sol_user	VARCHAR(10)	not null,
amo_user	VARCHAR(10)	not null,
cod_prize	CHAR(4)		not null,
dat_win		DATETIME	not null,
)
GO

ALTER TABLE dbo.GT_WINNER
ADD CONSTRAINT PKCODIGO_WINNER
PRIMARY KEY (sol_user,amo_user,cod_prize)
GO

ALTER TABLE dbo.GT_WINNER
ADD CONSTRAINT FKCOD_USER
FOREIGN KEY (sol_user,amo_user) REFERENCES dbo.GT_USER(sol_user,amo_user)
GO

ALTER TABLE dbo.GT_WINNER
ADD CONSTRAINT FKCOD_PRIZE
FOREIGN KEY (cod_prize) REFERENCES dbo.GT_PRIZE(cod_prize)
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Solicita la hora del servidor
Fecha de creacion:	-- 10/04/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- Ninguno
Parametros:		-- Ninguno
*********************************************************************/

CREATE PROCEDURE spgt_server_time
AS
BEGIN
	SELECT DATEPART(HOUR,GETDATE()) AS HOURS, DATEPART(MINUTE,GETDATE()) AS MINUTES
END
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Solicita stock de producto
Fecha de creacion:	-- 10/04/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- dbo.GT_PRIZE
Parametros:		-- @cod
*********************************************************************/

CREATE PROCEDURE spgt_stock
@cod VARCHAR(4)
AS
BEGIN
	SELECT st_prize from dbo.GT_PRIZE where cod_prize = @cod
END
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Solicita usuario por codigo de solicitud
Fecha de creacion:	-- 10/04/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- dbo.GT_USER
Parametros:		-- @cod
*********************************************************************/

CREATE PROCEDURE spgt_consulta_cliente
@cod VARCHAR(10)
AS
BEGIN
	SELECT COUNT (*) FROM dbo.GT_USER WHERE sol_user = @cod
END
GO

/*******************************************************************
Autor:			-- 3S GAMES
Descripcion:      	-- Inserta usuario por codigo de solicitud
Fecha de creacion:	-- 10/04/2013
Base de Datos:		-- BD_GRANTIPO
Tablas:			-- dbo.GT_USER
Parametros:		-- @sol,@cod,@dni
*********************************************************************/

CREATE PROCEDURE spgt_insertar_cliente
@sol VARCHAR(10),
@amo VARCHAR(10)
AS
BEGIN
	INSERT INTO dbo.GT_USER VALUES(@sol,@amo,GETDATE());
END
GO

/*-----INSERTS----*/
insert into dbo.GT_PRIZE values('PZ01','CAT01',50,30);
insert into dbo.GT_PRIZE values('PZ02','CAT02',100,20);
insert into dbo.GT_PRIZE values('PZ03','CAT03',150,10);
insert into dbo.GT_PRIZE values('PZ04','CAT04',300,5);

exec spgt_stock 'PZ01';
exec spgt_consulta_cliente '1234567890';

SELECT * FROM dbo.GT_USER