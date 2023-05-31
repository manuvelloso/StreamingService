/*Listar los usuarios y sus perfiles que vieron durante el año 2023, la serie “GAME OF THRONES”. 
Indicar cuántos la vieron en idioma original y cuántos en castellano. */

WITH UsuariosGT AS (
	SELECT 
		usuario.Username,
		usuario.Email,
		usuario.Telefono,
		GOT.IdiomaAudio
	FROM (
		SELECT
			historial.Username,
			historial.IdiomaAudio
		FROM 
			historial
		INNER JOIN capitulo ON historial.TiOriginal = capitulo.TiOriginal 
		WHERE 
			NombreSerie LIKE 'Game of Thrones'
			AND YEAR(historial.FechaVisto) = 2023
		GROUP BY historial.Username, historial.IdiomaAudio
    ) AS GOT
	INNER JOIN usuario ON GOT.Username = usuario.Username
)

SELECT 
	IdiomaAudio, 
	count(IdiomaAudio) as Cantidad
FROM 
	UsuariosGT 
GROUP BY IdiomaAudio
ORDER BY Cantidad
