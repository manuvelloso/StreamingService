-- Listar las 5 series más vistas por los clientes de entre 25 y 35 años. 

SELECT 
    Serie,
    COUNT(Serie) AS Vistas
FROM (
    SELECT 
        capitulo.NombreSerie AS Serie
    FROM 
        capitulo
        INNER JOIN historial ON capitulo.TiOriginal = historial.TiOriginal
        INNER JOIN usuario ON historial.Username = usuario.Username 
    WHERE 
        YEAR(usuario.FechaNac) BETWEEN YEAR(CURDATE()) - 35 AND YEAR(CURDATE()) - 25
    GROUP BY capitulo.NombreSerie, historial.Username
) AS Reducida
GROUP BY Serie
ORDER BY Vistas DESC
LIMIT 5;



