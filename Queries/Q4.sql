-- Listar las 5 series más vistas por los clientes de entre 25 y 35 años. 

SELECT 
    Serie,
    COUNT(Serie) AS Vistas
FROM (
    SELECT 
        capitulo.NombreSerie AS Serie
    FROM 
        capitulo
        INNER JOIN reproduccionencurso ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
        INNER JOIN usuario ON reproduccionencurso.Username = usuario.Username 
    WHERE 
        YEAR(usuario.FechaNac) BETWEEN YEAR(CURDATE()) - 35 AND YEAR(CURDATE()) - 25
    GROUP BY capitulo.NombreSerie, reproduccionencurso.Username
) AS Reducida
GROUP BY Serie
ORDER BY Vistas DESC
LIMIT 5;



