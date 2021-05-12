USE [Bvsoft]
GO

/****** Object:  StoredProcedure [dbo].[sp_MantenimientoObjetos]    Script Date: 11/5/2021 2:33:27 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*  
  ESTE TEXTO ES PARA COMPROBAR QUE SI SE ACTUALIZÓ DESDE LA PÁIGNA DE DESCARGA
  Stored Procedure de Registro de todos los Objetos del Sistema BVSoft
     Creado Por J.Rodríguez.- 
     *****  Este recibe como parametro todos los campos de la tabla de lista negra
              ADD--> Crea un registro
              UPD--> Modifica un registro
              DEL-->  Borra un registro  
                 
               el cual devuelve
               0-  el proceso se realiza sin error
               1-  Trata de crear un registro que ya existe, es decir no se pueden duplicar el codigo de un regristro
               2.- Trata de modificar un registro que no existe
               3.- Trata de borrar un registro que no existe
  
*/
ALTER PROCEDURE [dbo].[sp_MantenimientoObjetos] (
@modo char(3),
@codigo numeric,
@descripcion varchar (200),
@tipo_objeto varchar(20),
@observacion varchar (800),
@fecha datetime)
--Reemplazar   WITH ENCRYPTION
 AS

IF @modo = 'ADD' /* si voy a añadir un registro nuevo */
BEGIN
	IF EXISTS (SELECT codigo FROM OBJETOS  WHERE  codigo  = @codigo) return (1)  /* Si existe, retorno 1, para no tratar de duplicar codigo  */
	ELSE
	BEGIN
		INSERT OBJETOS (descripcion, tipo_objeto, observacion, fecha)  VALUES (@descripcion, @tipo_objeto, @observacion, getdate())
    END 
END

IF @modo = 'UPD'  /* Modificar un registro que ya existe */
BEGIN
	IF EXISTS (SELECT codigo FROM OBJETOS WHERE  codigo = @codigo)
	BEGIN
		UPDATE OBJETOS SET
			descripcion     =  @descripcion,
			tipo_objeto       =  @tipo_objeto,
			observacion		  =  @observacion
		WHERE codigo =  @codigo

	END
	ELSE	
		RETURN(2)  /* el registro que se quiere modificar no existe   */
END

IF @modo = 'DEL'    /* Borrar el registro */

BEGIN
		IF EXISTS (SELECT codigo FROM OBJETOS WHERE codigo = @codigo)
		BEGIN
			DELETE OBJETOS
			 WHERE  codigo = @codigo
		END
	ELSE
		 RETURN (3)    /* El registro que se quiere borrar no existe */
END



















































































GO


