CREATE VIEW Buscar_genero AS (
  -- Ejemplo para género anime
  SELECT TiOriginal
  FROM contenido
  WHERE Genero LIKE 'Anime'
);
