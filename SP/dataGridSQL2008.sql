USE [rr_]
GO
/****** Object:  StoredProcedure [dbo].[dataGrid]    Script Date: 05/05/2015 00:12:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[dataGrid]
	@flag char(1),
	@criterio VARCHAR(200),
	@pagina INT,
	@reg_x_pag INT
AS
BEGIN
	-- Insert statements for procedure here
	DECLARE @maximo numeric
	DECLARE @minimo numeric
	DECLARE @total NUMERIC
    
    SET @maximo = (@pagina * @reg_x_pag)
    SET @minimo = @maximo - (@reg_x_pag - 1)
    
    SELECT 
		@total = COUNT(*) 
	FROM f_trabajador 
	WHERE nombres LIKE '%'+@criterio+'%'
	
    --CREACION DE LA TABLA TEMPORAL PARA LA PAGINACION
    --NUM_ORDEN SERVIRA DE INDICE PARA EXTRAER LOS REGISTROS

	-- AQUI TU TABLA
    CREATE TABLE #tmpListado(
        num_orden int IDENTITY(1,1),
		nombres nvarchar(35) NULL,
        apellidos nvarchar(35) NULL
    )
    
    --INSERTAR LOS DATOS A LA TABLA TEMPORAL DIRECTAMENTE DESDE EL SELECT
    INSERT #tmpListado 
    SELECT 
		nombres,
		apellidos 
	FROM f_trabajador 
	WHERE nombres LIKE '%'+@criterio+'%' -- PARA CUANDO QUIERAS FILTRAR
	
	--UNA VEZ CARGADOS LOS DATOS LOS EXTRAEMOS
    --CON UN SELECT FILTRADO POR LOS VALORES DE LA PAGINACION
    SELECT 
		nombres,
		apellidos,
		@total AS total
    FROM #tmpListado
    WHERE num_orden BETWEEN @minimo AND @maximo
    
    /*
    
    SELECT 
		* 
	FROM 
	( 
		SELECT 
			ROW_NUMBER() OVER ( ORDER BY nombres ) AS RowNum, 
			nombres,
			apellidos,
			@total AS total
		FROM f_trabajador 
		WHERE nombres LIKE '%'+@criterio+'%' -- PARA CUANDO QUIERAS FILTRAR
	 ) AS DATA 
	WHERE RowNum BETWEEN @minimo AND @maximo ORDER BY RowNum
	*/
END
