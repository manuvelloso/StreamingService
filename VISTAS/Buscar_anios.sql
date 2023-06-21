CREATE VIEW buscar_anios AS (
  -- Ejemplo para rango de años entre 2013 y 2020
  SELECT TiOriginal
  FROM contenido
  WHERE AnioLanzamiento BETWEEN 2013 AND 2020
);
