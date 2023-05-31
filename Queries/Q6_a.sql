SELECT 
		usuario.Username,
		usuario.Email,
		usuario.Telefono
	FROM (
		SELECT
			historial.Username
		FROM 
			historial
		INNER JOIN capitulo ON historial.TiOriginal = capitulo.TiOriginal 
		WHERE 
			NombreSerie LIKE 'Game of Thrones'
			AND YEAR(historial.FechaVisto) = 2023
		GROUP BY historial.Username
    ) AS GOT
	INNER JOIN usuario ON GOT.Username = usuario.Username