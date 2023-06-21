CREATE VIEW sugerencias_Genero AS (

-- Lo que marcó como me encanta y me gusta (Valor = 1, 2)
-- - Género
-- - Director
-- - Ordenar por calificacion avg

-- EJEMPLO con usuario vivkyguar
-- Primero con genero

  WITH genero_MGME AS (
    SELECT
      Genero,
      COUNT(Genero) AS cant_genero
    FROM califica 
    INNER JOIN contenido ON contenido.TiOriginal = califica.TiOriginal
    WHERE (Username LIKE 'vickyguar' AND (Valor = 4 OR Valor = 5)) -- lo que marcó como me gusta y me encanta
    GROUP BY Genero
    ORDER BY cant_genero
    LIMIT 1
  )
  SELECT contenido.TiOriginal, CalifAverage
  FROM reproduccionencurso
  RIGHT OUTER JOIN contenido ON reproduccionencurso.TiOriginal = contenido.TiOriginal
  WHERE (contenido.Genero IN (SELECT Genero FROM genero_MGME) AND reproduccionencurso.TiOriginal IS NULL)
  ORDER BY CalifAverage
  LIMIT 10
);

