CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`descarga_BEFORE_INSERT_1` BEFORE INSERT ON `descarga` FOR EACH ROW
BEGIN
	
    SELECT FechaNac
    FROM descarga INNER JOIN usuario ON descarga.Username = usuario.Username
    WHERE Username = NEW.Username;
    
    SELECT CalifSalida
    FROM 
    (SELECT TiOriginal FROM descarga 
    INNER JOIN pelicula ON descarga.TiOriginal = pelicula.TiOriginal
    
    UNION
    
    SELECT TiOriginal FROM descarga 
    INNER JOIN documental ON descarga.TiOriginal = documental.TiOriginal
    
    UNION
    
    SELECT NombreSerie AS TiOriginal FROM descarga 
    INNER JOIN capitulo ON capitulo.TiOriginal = descarga.TiOriginal
    INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie
    );
    
    
	IF YEAR(CURDATE()) - YEAR(FechaNac) < 13 AND  CalifSalida LIKE 'ATP' THEN
		INSERT INTO descarga(Username, TiOriginal, Calidad)
		VALUES (NEW.Username, NEW.TiOriginal, NEW.Calidad);
	END IF;
	
    
END