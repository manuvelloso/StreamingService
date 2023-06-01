CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`reproduccionencurso_BEFORE_UPDATE` BEFORE UPDATE ON `reproduccionencurso` FOR EACH ROW
BEGIN

SELECT
TipoDisp, ModeloDisp
FROM reproduccionencurso INNER JOIN usuario ON usuario.Username = TipoDisp.Username
INNER JOIN dispositivo ON usuario.Username = dispositivo.Username
WHERE reproduccionencurso.idReproduccion = NEW.reproduccionencurso.idReproduccion;

IF TipoDisp IN ('celular', 'tablet') AND Modelo LIKE 'alta gama' THEN
	UPDATE reproduccionencurso
	SET Velocidad = NEW.Velocidad
	WHERE (idReproduccion = NEW.idReproduccion);
END IF;

END
