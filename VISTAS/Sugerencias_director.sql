CREATE VIEW sugerencias_Director AS (
  WITH director_MGME AS (
    SELECT
      Director,
      COUNT(Director) AS cant_director
    FROM califica 
    INNER JOIN contenido ON contenido.TiOriginal = califica.TiOriginal
    WHERE (Username LIKE 'vickyguar' AND (Valor = 4 OR Valor = 5)) -- lo que marcó como me gusta y me encanta
    GROUP BY Director
    ORDER BY cant_director
    LIMIT 1
  )
  SELECT contenido.TiOriginal, CalifAverage
  FROM reproduccionencurso
  RIGHT OUTER JOIN contenido ON reproduccionencurso.TiOriginal = contenido.TiOriginal
  WHERE (contenido.Director IN (SELECT Director FROM director_MGME) AND reproduccionencurso.TiOriginal IS NULL)
  ORDER BY CalifAverage
  LIMIT 10
);
