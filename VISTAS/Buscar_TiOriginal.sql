CREATE VIEW Buscar_Titulo AS (
SELECT *
FROM contenido 
WHERE contenido.TiOriginal LIKE 'The Last of Us' OR 'The Last of Us' IN (SELECT NombreSerie FROM serie)
);