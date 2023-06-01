CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`reproduccionencurso_BEFORE_INSERT` BEFORE INSERT ON `reproduccionencurso` FOR EACH ROW
BEGIN
 SELECT FechaNac
    FROM reproduccionencurso INNER JOIN usuario ON reproduccionencurso.Username = usuario.Username
    WHERE Username = NEW.Username;
    
    SELECT CalifSalida
    FROM 
    (SELECT TiOriginal FROM reproduccionencurso 
    INNER JOIN pelicula ON descarga.TiOriginal = pelicula.TiOriginal
    
    UNION
    
    SELECT TiOriginal FROM reproduccionencurso 
    INNER JOIN documental ON reproduccionencurso.TiOriginal = documental.TiOriginal
    
    UNION
    
    SELECT NombreSerie AS TiOriginal FROM reproduccionencurso 
    INNER JOIN capitulo ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
    INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie
    );
    
    
	IF YEAR(CURDATE()) - YEAR(FechaNac) < 13 AND  CalifSalida LIKE 'ATP' THEN
		INSERT INTO reproduccionencurso(TiOriginal, Username, Velocidad, PtoSuspenso, FechaVisto, IdiomaAudio, IdiomaSubtitulo)
		VALUES (NEW.TiOriginal, NEW.Username, NEW.Velocidad, NEW.PtoSuspenso, NEW.FechaVisto, NEW.IdiomaAudio, NEW.IdiomaSubtitulo);
	END IF;
	
END
