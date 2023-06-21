CREATE VIEW Buscar_historial AS (
  -- Ejemplo para el historial de vickyguar
  SELECT contenido.TiOriginal
  FROM reproduccionencurso
  INNER JOIN contenido ON reproduccionencurso.TiOriginal = contenido.TiOriginal
  WHERE reproduccionencurso.PtoSuspenso = contenido.Duracion
    AND Username LIKE 'vickyguar'
);
