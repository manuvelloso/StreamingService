CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`usuario_BEFORE_INSERT` BEFORE INSERT ON `usuario` FOR EACH ROW
BEGIN

DECLARE TotalUsuarios INT UNSIGNED;
    SELECT SUM(usuario.Email) INTO TotalUsuarios
    FROM usuario 
    GROUP BY Email;
    
    IF TotalUsuarios >= 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya hay 3 usuarios en la cuenta';
    ELSE
		INSERT INTO usuario (Username, Email, Telefono, FechaNac)
		VALUES (NEW.Username, NEW.Email, NEW.Telefono, NEW.FechaNac);
	END IF;

END
