SELECT 
		usuario.Username,
		usuario.Email,
		usuario.Telefono
	FROM (
		SELECT
			reproduccionencurso.Username
		FROM 
			historial
		INNER JOIN capitulo ON reproduccionencurso.TiOriginal = capitulo.TiOriginal 
		WHERE 
			NombreSerie LIKE 'Game of Thrones'
			AND YEAR(reproduccionencurso.FechaVisto) = 2023
		GROUP BY historial.Username
    ) AS GOT
	INNER JOIN usuario ON GOT.Username = usuario.Username
