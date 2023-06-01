CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`usuario_BEFORE_INSERT_1` BEFORE INSERT ON `usuario` FOR EACH ROW
BEGIN

DECLARE fechanaci DATE;
SELECT NEW.FechaNac INTO fechanaci;

IF YEAR(fechanaci > CURDATE()) OR YEAR(NEW.FechaNac) < 1910 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fecha de nacimiento inválida';
ELSE
	INSERT INTO usuario (Username, Email, Telefono, FechaNac)
	VALUES (NEW.Username, NEW.Email, NEW.Telefono, fechanaci);
END IF;

END