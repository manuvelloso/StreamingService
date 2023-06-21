CREATE VIEW Buscar_calificacion_usuarios AS (
  -- Ejemplo para calificacion de 4,5 estrellas
  SELECT TiOriginal
  FROM contenido
  WHERE CalifAverage = 4.5
);
