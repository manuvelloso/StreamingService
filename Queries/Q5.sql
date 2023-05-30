-- Listar los documentales disponibles sobre COVID que hayan sido estrenados entre 2020 y 2022. 

SELECT 
	TiOriginal AS Documentales
FROM 
	documental
WHERE 
	AnioLanzamiento BETWEEN 2020 AND 2022 AND Tema LIKE "%COVID%" -- YEAR(AnioLanzamiento) BETWEEEN 2020 AND 2022 

