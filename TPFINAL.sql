-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb_final
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb_final` DEFAULT CHARACTER SET utf8mb3 ;
USE `mydb_final` ;

-- -----------------------------------------------------
-- Table `mydb_final`.`cuenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`cuenta` (
  `Email` VARCHAR(30) NOT NULL,
  `Contrasenia` VARCHAR(20) NOT NULL,
  `Tarjeta` VARCHAR(20) NOT NULL,
  `Idioma` VARCHAR(3) NOT NULL,
  CONSTRAINT `Const_cuenta_contrasenia` CHECK(Contrasenia LIKE'%________'),
  CONSTRAINT `Const_cuenta_mail` CHECK (Email LIKE '%@%'),
  CONSTRAINT `Const_cuenta_idioma` CHECK (Idioma IN ('ES','EN')),
  CONSTRAINT `Const_cuenta_tarjeta` CHECK (Tarjeta LIKE '____ ____ ____ ____'),
  PRIMARY KEY (`Email`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`abono`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`abono` (
  `Factura` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Email` VARCHAR(30) NOT NULL,
  `Monto` FLOAT /*UNSIGNED*/ NOT NULL,
  `FechaVTO` DATE NOT NULL,
  `FechaPago` DATE NULL DEFAULT NULL,
  `FormaPago` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Factura`),
  INDEX `fk_abono_cuenta` (`Email` ASC) VISIBLE,
  CONSTRAINT `Çonst_abono_formapago` CHECK (FormaPago IN ('Debito cuenta bancaria','Tarjeta','Comprobante')),
  CONSTRAINT `fk_abono_cuenta` FOREIGN KEY (`Email`) REFERENCES `mydb_final`.`cuenta` (`Email`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`actor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`actor` (
  `idActor` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ActNombre` VARCHAR(45) NOT NULL,
  `ActApellido` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idActor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`contenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`contenido` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Duracion` INT UNSIGNED NOT NULL,
  `Genero` VARCHAR(30) NOT NULL,
  `Director` VARCHAR(45) NOT NULL,
  `CalifAverage` FLOAT UNSIGNED NULL DEFAULT NULL,
  `AnioLanzamiento` INT UNSIGNED NOT NULL,
  CONSTRAINT `Const_contenido_genero` CHECK(Genero IN ('Accion y aventura', 'Anime', 'Comedia', 'Documental', 'Drama', 'Fantasia', 'Terror', 'Extranjera', 'Nacional', 'Familiar', 'Misterio', 'Thriller', 'Romance')),
  CONSTRAINT `Const_contendio_duracion` CHECK(Duracion<270), -- no puede durar + de 4 horas y media
  PRIMARY KEY (`TiOriginal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`actua`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`actua` (
  `idActuacion` INT NOT NULL AUTO_INCREMENT,
  `idActor` INT UNSIGNED NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idActuacion`),
  INDEX `fk_actua_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_actua_actor1` (`idActor` ASC) VISIBLE,
  CONSTRAINT `fk_actua_actor1` FOREIGN KEY (`idActor`) REFERENCES `mydb_final`.`actor` (`idActor`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_actua_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`audio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`audio` (
  `idAudio` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Audio` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idAudio`),
  CONSTRAINT `Const_audio_Audio` CHECK(Audio IN ('original', 'castellano','ingles'))
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`audiocontenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`audiocontenido` (
  `idAudioContenido` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idAudio` INT UNSIGNED NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idAudioContenido`),
  INDEX `fk_audioContenido_Audio1_idx` (`idAudio` ASC) VISIBLE,
  INDEX `fk_audioContenido_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_audioContenido_Audio1` FOREIGN KEY (`idAudio`) REFERENCES `mydb_final`.`audio` (`idAudio`),
  CONSTRAINT `fk_audioContenido_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`usuario` (
  `Username` VARCHAR(20) NOT NULL,
  `Email` VARCHAR(30) NOT NULL,
  `Telefono` VARCHAR(10) NOT NULL,
  `FechaNac` DATE NOT NULL,
  PRIMARY KEY (`Username`),
  INDEX `fk_usuario_cuenta1_idx` (`Email` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_cuenta1` FOREIGN KEY (`Email`) REFERENCES `mydb_final`.`cuenta` (`Email`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE
  )
  ENGINE = InnoDB
  DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`califica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`califica` (
  `idCalificacion` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Calificacion` VARCHAR(30) NOT NULL,
  `Valor` INT NOT NULL,
  PRIMARY KEY (`idCalificacion`),
  INDEX `fk_califica_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_califica_usuario1` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_califica_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_califica_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `Const_califica_Calificacion` CHECK(Calificacion IN ('no me gusto','me gusto un poco','no me decido','me gusta bastante','me encanto'))
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`serie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`serie` (
  `NombreSerie` VARCHAR(45) NOT NULL,
  `TiEspañol` VARCHAR(45) NOT NULL,
  `TiIngles` VARCHAR(45) NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(20) NULL DEFAULT NULL,
  `CantidadTemp` INT UNSIGNED NOT NULL,
  CONSTRAINT `Cont_serie_CalifSalida` CHECK (CalifSalida IN ('ATP','13','16','18')),
  PRIMARY KEY (`NombreSerie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`capitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`capitulo` (
  `idCapitulo` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `TiOriginal` VARCHAR(40) NOT NULL,
  `NombreSerie` VARCHAR(45) NOT NULL,
  `NumCap` INT UNSIGNED NOT NULL,
  `NumTemp` INT UNSIGNED NOT NULL,
  PRIMARY KEY (idCapitulo),
  INDEX `fk_capitulo_serie1_idx` (`NombreSerie` ASC) VISIBLE,
  CONSTRAINT `fk_capitulo_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_capitulo_serie1` FOREIGN KEY (`NombreSerie`) REFERENCES `mydb_final`.`serie` (`NombreSerie`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`descarga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`descarga` (
  `idDescarga` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Calidad` VARCHAR(10) NOT NULL,
  `idDispositivo` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idDescarga`),
  INDEX `fk_descarga_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_descarga_usuario1` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_descarga_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_descarga_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `Const_descarga_Calidad` CHECK(Calidad IN ('normal','HD','UHD')),
  CONSTRAINT `fk_descarga_idDisp` FOREIGN KEY (`idDispositivo`) REFERENCES `mydb_final`.`dispositivo` (`idDispositivo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
)
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`dispositivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`dispositivo` (
  `idDispositivo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `DispNom` VARCHAR(20) NOT NULL,
  `MarcaDisp` VARCHAR(20) NOT NULL,
  `TipoDisp` VARCHAR(10) NOT NULL,
  `ModeloDisp` VARCHAR(10) NOT NULL,
  `RedWifi` VARCHAR(20) NULL DEFAULT NULL,
  CONSTRAINT `Const_dispositivo_TipoDisp` CHECK(TipoDisp IN ('celular','tablet','TV', 'PC')),
  CONSTRAINT `Const_dispositivo_ModeloDisp` CHECK(ModeloDisp IN('alta gama','media gama','baja gama')),
  PRIMARY KEY (`idDispositivo`),
  INDEX `fk_dispositivo_usuario1_idx` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_dispositivo_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`documental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`documental` (
  `idDocumental` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Tema` VARCHAR(20) NOT NULL,
  PRIMARY KEY (idDocumental),
  CONSTRAINT `fk_documental_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`favorito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`favorito` (
  `idFavorito` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idFavorito`),
  INDEX `fk_favorito_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_favorito_usuario1` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_favorito_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_favorito_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`pelicula`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`pelicula` (
  `idPelicula` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `TiIngles` VARCHAR(45) NOT NULL,
  `TiEspaniol` VARCHAR(45) NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(10) NOT NULL,
  CONSTRAINT `Const_pelicula_CalifSalida` CHECK(CalifSalida IN ('ATP','13','16','18')),
  PRIMARY KEY (`idPelicula`),
  CONSTRAINT `fk_pelicula_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`premio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`premio` (
  `idPremio` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idPelicula` INT UNSIGNED NOT NULL,
  `Anio` INT UNSIGNED NOT NULL,
  `Categoria` VARCHAR(20) NOT NULL,
  `Festival` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idPremio`),
  INDEX `fk_premio_pelicula1` (`idPelicula` ASC) VISIBLE,
  CONSTRAINT `fk_premio_pelicula1` FOREIGN KEY (`idPelicula`) REFERENCES `mydb_final`.`pelicula` (`idPelicula`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`reproduccionencurso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`reproduccionencurso` (
  `idReproduccion` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idDispositivo` INT UNSIGNED NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `Velocidad` FLOAT UNSIGNED NOT NULL,
  `PtoSuspenso` INT UNSIGNED NOT NULL,
  `FechaVisto` DATE NOT NULL,
  `IdAudio` INT UNSIGNED NOT NULL,
  `IdSubtitulo` INT UNSIGNED NULL DEFAULT NULL,
  CONSTRAINT `Const_reproduccion_Velocidad` CHECK(Velocidad IN (0.75,1,1.25,1.5)),
  PRIMARY KEY (`idReproduccion`),
  INDEX `fk_reproduce_usuario1_idx` (`Username` ASC) VISIBLE,
  INDEX `fk_reproduce_contenido10` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_reproduce_contenido10` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reproduce_usuario10` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reproduce_dispositivo` FOREIGN KEY (`idDispositivo`) REFERENCES `mydb_final`.`dispositivo` (`idDispositivo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reproduce_audio` FOREIGN KEY (`idAudio`) REFERENCES `mydb_final`.`audiocontenido` (`idAudio`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
 CONSTRAINT `fk_reproduce_sub` FOREIGN KEY (`idSubtitulo`) REFERENCES `mydb_final`.`subtitulocontenido` (`idSubtitulo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`subtitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`subtitulo` (
  `idSubtitulo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `IdiomaSubtitulo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idSubtitulo`),
  CONSTRAINT `Const_subtitulo_IdiomaSubtitulo` CHECK(IdiomaSubtitulo IN (NULL, 'castellano', 'ingles', 'portugues', 'italiano', 'frances'))
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`subtitulocontenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`subtitulocontenido` (
  `idSubtituloContenido` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idSubtitulo` INT UNSIGNED NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idSubtituloContenido`),
  INDEX `fk_subtituloContenido_subtitulo1_idx` (`idSubtitulo` ASC) VISIBLE,
  INDEX `fk_subtituloContenido_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_subtituloContenido_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_subtituloContenido_subtitulo1` FOREIGN KEY (`idSubtitulo`) REFERENCES `mydb_final`.`subtitulo` (`idSubtitulo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`casting`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`casting` (
  `idCasting` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idReproduccion` INT UNSIGNED NOT NULL, 
  `DispEmisor` INT UNSIGNED NOT NULL,
  `DispReceptor` INT UNSIGNED NOT NULL,
  -- CONSTRAINT `Const_casting_disp` CHECK(DispEmisor!=DispReceptor),
  PRIMARY KEY (`idCasting`),
  INDEX `fk_casting_dispositivo1_idx` (`DispEmisor` ASC) VISIBLE,
  INDEX `fk_casting_dispositivo2_idx` (`DispReceptor` ASC) VISIBLE,
  CONSTRAINT `fk_casting_dispositivo1` FOREIGN KEY (`DispEmisor`) REFERENCES `mydb_final`.`dispositivo` (`idDispositivo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_casting_dispositivo2` FOREIGN KEY (`DispReceptor`) REFERENCES `mydb_final`.`dispositivo` (`idDispositivo`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_casting_Reproduccion` FOREIGN KEY (`idReproduccion`) REFERENCES `mydb_final`.`reproduccionencurso` (`idReproduccion`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
    
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb_final`.`watchparty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`watchparty` (
  `idWatchparty` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserEmisor` VARCHAR(20) NOT NULL,
  `UserReceptor` VARCHAR(20) NOT NULL,
  `idReproduccion` INT UNSIGNED NOT NULL,
  -- CONSTRAINT `Const_watchpary_User` CHECK (UserEmisor != UserReceptor),
  PRIMARY KEY (`idWatchparty`),
  INDEX `fk_watchparty_usuario1_idx` (`UserEmisor` ASC) VISIBLE,
  INDEX `fk_watchparty_usuario2_idx` (`UserReceptor` ASC) VISIBLE,
  CONSTRAINT `fk_watchparty_usuario1` FOREIGN KEY (`UserEmisor`) REFERENCES `mydb_final`.`usuario` (`Username`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_watchparty_usuario2` FOREIGN KEY (`UserReceptor`) REFERENCES `mydb_final`.`usuario` (`Username`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_watchparty_idReproduccion` FOREIGN KEY (`idReproduccion`) REFERENCES `mydb_final`.`reproduccionencurso` (`idReproduccion`)
	ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

DELIMITER $$
USE `mydb_final`$$

/*
--CALIFICA: before instert--------------------------------
- El usuario tiene que haber visto lo que va a calificar 
- Un niño no puede calificar contenido que no sea ATP    
- El usuario no puede calificar si tiene el abono vencido
----------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `califica_BEFORE_INSERT` BEFORE INSERT ON `califica` FOR EACH ROW BEGIN
    DECLARE fechita DATE;
    DECLARE califi VARCHAR(10);
    DECLARE VTO DATE;
    DECLARE puntito INT UNSIGNED;
    DECLARE duracioncita INT UNSIGNED;
    
    --
    SELECT PtoSuspenso, Duracion INTO puntito, duracioncita
    FROM califica 
    INNER JOIN reproduccionencurso ON califica.TiOriginal = reproduccionencurso.TiOriginal
    INNER JOIN contenido ON contenido.TiOriginal = reproduccionencurso.TiOriginal
    WHERE(califica.Username = NEW.Username AND califica.TiOriginal = NEW.TiOriginal);
    
    -- NIÑOS --
    SELECT FechaNac INTO fechita
    FROM califica INNER JOIN usuario ON califica.Username = usuario.Username
    WHERE califica.Username = NEW.Username;

    SELECT CalifSalida INTO califi
    FROM 
    (
        -- Pelicula
        (SELECT pelicula.TiOriginal AS Titulo, CalifSalida FROM califica 
        INNER JOIN pelicula ON califica.TiOriginal = pelicula.TiOriginal) 
        
        UNION
        
        -- Serie
        (SELECT capitulo.TiOriginal AS Titulo, CalifSalida FROM califica 
        INNER JOIN capitulo ON capitulo.TiOriginal = califica.TiOriginal
        INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
    ) AS e
    WHERE Titulo = NEW.TiOriginal;

    -- ABONO VENCIDO --
    SELECT FechaVTO INTO VTO
    FROM califica 
    INNER JOIN usuario ON califica.Username = usuario.Username
    INNER JOIN abono ON usuario.Email = abono.Email
    WHERE usuario.Username = NEW.Username

    -- Si el abono está vencido
    IF CURDATE() >= VTO + INTERVAL 5 DAY THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
    -- Si no
    ELSE
        -- Si es niño
        IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
	ELSE
		-- Si no terminó de ver
		IF PtoSuspenso <> Duracioncita THEN 
	 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No podes calificar algo que todavía no terminaste de ver :P';
            	ELSE
			-- Si no: lo puedo ingresar!
			IF NEW.Calificacion LIKE 'no me gusto' THEN
				SET NEW.Valor = 1;
			END IF;
			
			IF NEW.Calificacion LIKE 'no me decido' THEN
				SET NEW.Valor = 2;
			END IF;
				
			IF NEW.Calificacion LIKE 'me gusto un poco' THEN
				SET NEW.Valor = 3;
			END IF;
				
			IF NEW.Calificacion LIKE 'me gusta bastante' THEN
				SET NEW.Valor = 4;
			END IF;
				
			IF NEW.Calificacion LIKE 'me encanto' THEN
				SET NEW.Valor = 5;
			END IF;
		END IF;
        END IF;
    END IF;
END$$

/*
--CALIFICA: after insert----------------------------------
- Se debe modificar la calificacion average del contenido
----------------------------------------------------------
*/	
CREATE DEFINER=`root`@`localhost` TRIGGER `califica_AFTER_INSERT` AFTER INSERT ON `califica` FOR EACH ROW BEGIN
    -- Variables
    DECLARE CalTotal INT UNSIGNED;
    DECLARE CantCal INT UNSIGNED;
    DECLARE NuevaCal FLOAT;
    
    SELECT COUNT(*), SUM(Valor) INTO CantCal, CalTotal
    FROM califica
    WHERE TiOriginal = NEW.TiOriginal;
    
    -- Calcular la nueva calificación promedio
    SET NuevaCal = CalTotal / CantCal;
    
    -- Actualizar la calificación promedio en la tabla de contenido
    UPDATE contenido
    SET CalifAverage = NuevaCal
    WHERE CalifAverage.TiOriginal = NEW.TiOriginal;
END$$

/*
--CASTING: before insert---------------------------------------------------------------
- los dispositivos que se van a castear tienen que estar conectados a la misma red wifi
- no se puede castear un dispositivo consigo mismo
---------------------------------------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `casting_BEFORE_INSERT` BEFORE INSERT ON `casting` FOR EACH ROW BEGIN
	-- Variables
	DECLARE W1 VARCHAR(20);
	DECLARE W2 VARCHAR(20);
	DECLARE id1 INT UNSIGNED;
	DECLARE id2 INT UNSIGNED;
	
	SELECT idDispositivo INTO id1
	FROM casting INNER JOIN dispositivo ON casting.DispEmisor = dispositivo.idDispositivo
	WHERE casting.DispEmisor = NEW.DispEmisor;
	
	SELECT idDispositivo INTO id2
	FROM casting INNER JOIN dispositivo ON casting.DispReceptor = dispositivo.idDispositivo
	WHERE casting.DispReceptor = NEW.DispReceptor;
	
	SELECT RedWifi INTO W1 
	FROM casting INNER JOIN dispositivo 
	ON dispositivo.idDispositivo = casting.DispEmisor;
	
	SELECT RedWifi INTO W2 
	FROM casting INNER JOIN dispositivo 
	ON dispositivo.idDispositivo = casting.DispReceptor;
	
	IF id1 = id2 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede castear un dispositivo con si mismo';
	ELSE
		IF W1 NOT LIKE w2 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en la conexión WiFi de los dispositivos';
		END IF;
	END IF;
END$$

/*
--CASTING: after insert--------------------------
- casting anula el modo de reproducción acelerado
-------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `casting_AFTER_INSERT` AFTER INSERT ON `casting` FOR EACH ROW BEGIN

DECLARE id INT UNSIGNED;

SELECT idReproduccion INTO id
FROM casting
WHERE (casting.idReproduccion = NEW.idReproduccion);

UPDATE Reproduccionencurso
SET Reproduccionencurso.Velocidad = 1.0
WHERE(Reproduccionencurso.idReproduccion = id);

END$$

/*
--DESCARGA: before instert-------------------------------
- Solo pueden descargar los dispositivos de alta gam
- Máximo 4hs de descarga
- no puede descargar si no pagó
- Los niños no pueden descargar contenido que no sea ATP
---------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `descarga_BEFORE_INSERT` BEFORE INSERT ON `descarga` FOR EACH ROW BEGIN
	-- Variables
	DECLARE TotalMins INT UNSIGNED;
	DECLARE titulito VARCHAR(40);
	DECLARE fechita DATE;
	DECLARE VTO DATE;
	DECLARE califi VARCHAR(10);
	DECLARE gamita VARCHAR(10);
	
	-- CHEQUEO SI ES ALTA GAMA
	SELECT ModeloDisp INTO gamita
	FROM descarga INNER JOIN dispositivo ON descarga.idDispositivo = dispositivo.idDispositivo
	WHERE descarga.idDispositivo = NEW.idDispositivo;
	
	-- NO HAY ESPACIO PARA LA DESCARGA --
	SELECT SUM(contenido.Duracion) INTO TotalMins
	FROM descarga 
	INNER JOIN contenido ON descarga.TiOriginal = contenido.TiOriginal
	WHERE descarga.Username = NEW.Username;
	
	-- YA LO DESCARGÓ --
	SELECT TiOriginal INTO titulito
	FROM descarga
	WHERE (descarga.Username = NEW.Username AND descarga.TiOriginal = NEW.TiOriginal);
	
	-- ABONO VENCIDO --
	SELECT FechaVTO INTO VTO
	FROM descarga 
	INNER JOIN usuario ON descarga.Username = usuario.Username
	INNER JOIN abono ON usuario.Email = abono.Email
	WHERE usuario.Username = NEW.Username;
	
	-- NIÑOS --
	SELECT FechaNac INTO fechita
	FROM descarga INNER JOIN usuario ON descarga.Username = usuario.Username
	WHERE descarga.Username = NEW.Username;
		
	SELECT CalifSalida INTO califi
	FROM 
	(
	-- Pelicula
	(SELECT TiOriginal FROM descarga 
	INNER JOIN pelicula ON descarga.TiOriginal = pelicula.TiOriginal) 
	    
	UNION
	    
	-- Documental
	(SELECT TiOriginal FROM descarga 
	INNER JOIN documental ON descarga.TiOriginal = documental.TiOriginal)
	    
	UNION
	    
	-- Serie
	(SELECT NombreSerie AS TiOriginal FROM descarga 
	INNER JOIN capitulo ON capitulo.TiOriginal = descarga.TiOriginal
	INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
	) as e
	WHERE(capitulo.TiOriginal = NEW.TiOriginal);
	
	-- Si ya lo descargó
	IF titulito IS NOT NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'el contenido ya ha sido descargado por el usuario';
	ELSE
		-- Si no hay espacio
		IF TotalMins + (SELECT Duracion FROM contenido WHERE TiOriginal = NEW.TiOriginal) > 240 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO HAY ESPACIO. La descarga supera el límite de 4 horas de contenido.';
	   	 ELSE
			-- Si no pagó
			IF CURDATE() >= VTO + 5 THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
			ELSE 
				-- Si es niño
				IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
				ELSE
					-- no es de alta gama
					IF gamita NOT LIKE 'alta gama' THEN
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El dispositivo donde se quiso descargar no es de alta gama';
	             			   ELSE
						-- Si el dispositivo no le pertenece a la persona
	                    			IF NEW.idDispositivo NOT IN (SELECT idDispositivo FROM dispositivo WHERE dispositivo.Username = NEW.descarga.Username) THEN
							SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El dispositivo no le pertenece al usuario';
	                    			END IF;
	                		END IF;
				END IF;
			END IF;
		END IF;
	END IF;
END$$

/*
--DISPOSITIVO: before insert---------------
- máx 5 dispositivos vinculados por usuario
-------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `dispositivo_BEFORE_INSERT` BEFORE INSERT ON `dispositivo` FOR EACH ROW BEGIN
	-- Variable
	DECLARE cant INT UNSIGNED;
	
	SELECT count(Username) INTO cant
	FROM dispositivo
	WHERE (Username = NEW.Username) 
	GROUP BY Username;
	
	IF cant >= 5 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario ya tiene 5 dispositivos.';
	END IF;
END$$

/*
--CONTENIDO: before insert------------------------
- El año de lanzamiento no puede ser mayor que hoy
--------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `contenido_BEFORE_INSERT` BEFORE INSERT ON `contenido` FOR EACH ROW BEGIN
	IF NEW.AnioLanzamiento > YEAR(CURDATE()) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Año de lanzamiento inválido';
	END IF;
END$$

/*
--FAVORITO: before instert---------------------------------
- Máximo 10 favoritos
- Si no pagó, no puede marcar favorito
- Si es niño no puede marcar como favorito contenido no ATP
-----------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `favorito_BEFORE_INSERT` BEFORE INSERT ON `favorito` FOR EACH ROW BEGIN
    -- Variables
    DECLARE califi VARCHAR(10);
    DECLARE VTO DATE;
    DECLARE fechita DATE;
    DECLARE cant INT UNSIGNED;
    
    -- YA HAY 10 FAVS -- 
    SELECT count(Username) INTO cant
    FROM favorito
    WHERE(Username = NEW.Username)
    GROUP BY Username;

    -- NIÑOS --
    SELECT FechaNac INTO fechita
    FROM favorito INNER JOIN usuario ON favorito.Username = usuario.Username
    WHERE Username = NEW.Username;
	
    SELECT CalifSalida INTO califi
    FROM 
    (
    -- Pelicula
    (SELECT TiOriginal FROM favorito 
    INNER JOIN pelicula ON favorito.TiOriginal = pelicula.TiOriginal) 
    
    UNION
    
    -- Documental
    (SELECT TiOriginal FROM califica 
    INNER JOIN documental ON califica.TiOriginal = documental.TiOriginal)
    
    UNION
    
    -- Serie
    (SELECT NombreSerie AS TiOriginal FROM favorito 
    INNER JOIN capitulo ON capitulo.TiOriginal = favorito.TiOriginal
    INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
    ) as e
    WHERE(capitulo.TiOriginal = NEW.TiOriginal);
    
    -- ABONO VENCIDO --
	SELECT FechaVTO INTO VTO
	FROM favorito 
	INNER JOIN usuario ON favorito.Username = usuario.Username
	INNER JOIN abono ON usuario.Email = abono.Email
	WHERE usuario.Username = NEW.Username
	GROUP BY Email;
	
    -- si ya hay 10 títulos en favoritor
    IF cant >= 10 THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya hay 10 títulos en favoritos.';
    ELSE
		-- Si el abono está vencido
		IF CURDATE() >= VTO + 5 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
		-- Si no
		ELSE
			-- Si es niño
			IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
			END IF;
		END IF;
	END IF;
END$$

/*
--PREMIO: before insert--------------------------------------
- Una pelicula no puede ganar un premio antes de haber salido
-------------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `premio_BEFORE_INSERT` BEFORE INSERT ON `premio` FOR EACH ROW BEGIN
	-- Variable
	DECLARE aniesito INT UNSIGNED;
	
	SELECT AnioLanzamiento INTO aniesito
	FROM pelicula INNER JOIN contenido ON pelicula.TiOriginal = contenido.TiOriginal
	WHERE pelicula.idPelicula = NEW.idPelicula;
	
	IF NEW.Anio < aniesito THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La pelicula no pudo ganar un premio antes de haber sido lanzada';
	END IF;
END;

/*
--REPRODUCCION EN CURSO: before insert---------------------------------------------------------------------
- No pude reproducir nada si no pagó
- Los niños no pueden reproducir contenido ATP
- si no tiene wifi y no esta descargado no puede reproducir
- si no tiene wifi pero está descargado en modo 'normal' puede reproducir solo en castellano sin subtitulos
-----------------------------------------------------------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `reproduccionencurso_BEFORE_INSERT` BEFORE INSERT ON `reproduccionencurso` FOR EACH ROW BEGIN
	-- Variables
	DECLARE fechita DATE;
	DECLARE VTO DATE;
	DECLARE califi VARCHAR(10);
	DECLARE iAud INT UNSIGNED;
	DECLARE iSub INT UNSIGNED;
	DECLARE wifi_ VARCHAR(20);
	DECLARE descargado VARCHAR(40);
	DECLARE cal VARCHAR(10);
    
    SELECT NEW.IdAudio INTO iAud;
    SELECT NEW.IdSubtitulo INTO iSub;
    
    -- DESCARGA
    SELECT TiOriginal, Calidad INTO descargado, cal
    FROM reproduccionencurso 
    INNER JOIN descarga ON reproduccionencurso.TiOriginal = descarga.TiOriginal
    INNER JOIN usuario ON usuario.Username = descarga.Username
    WHERE reproduccionencurso.Username = NEW.Username;
    
    -- WIFI --
    SELECT Wifi INTO wifi_
    FROM reproduccionencurso 
    INNER JOIN dispositivo ON reproduccioencurso.idDisopositivo = dispositivo.idDispositivo
    WHERE reproduccioencurso.idDisopositivo = NEW.idDisopositivo;
    
    -- ABONO VENCIDO --
    SELECT FechaVTO INTO VTO
    FROM reproduccionencurso 
    INNER JOIN usuario ON reproduccionencurso.Username = usuario.Username
    INNER JOIN abono ON usuario.Email = abono.Email
    WHERE usuario.Username = NEW.usuario.Username


    -- NIÑOS --
    SELECT FechaNac INTO fechita
    FROM reproduccionencurso INNER JOIN usuario ON reproduccionencurso.Username = usuario.Username
    WHERE Username = NEW.Username;
	
    SELECT CalifSalida INTO califi
    FROM 
    (
    -- Pelicula
    (SELECT TiOriginal FROM reproduccionencurso 
    INNER JOIN pelicula ON reproduccionencurso.TiOriginal = pelicula.TiOriginal) 
    
    UNION
    
    -- Documental
    (SELECT TiOriginal FROM reproduccionencurso 
    INNER JOIN documental ON reproduccionencurso.TiOriginal = documental.TiOriginal)
    
    UNION
    
    -- Serie
    (SELECT NombreSerie AS TiOriginal FROM reproduccionencurso 
    INNER JOIN capitulo ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
    INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
    ) as e
    WHERE(capitulo.TiOriginal = NEW.TiOriginal);

-- Si no pagó
IF CURDATE() >= VTO + 5 THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Abono pendiente de pago.';
-- Sino
ELSE 
	-- Si es niño
	IF YEAR(CURDATE()) - YEAR(fechita) < 13 AND califi NOT LIKE 'ATP' THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
	-- Si no
        ELSE
		-- Si no tiene el audio seleccionado
		IF iAud NOT IN (SELECT idAudio FROM audiocontenido WHERE (audiocontenido.TiOriginal = NEW.TiOriginal)) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idioma de audio no disponible en este título';
		ELSE
			-- Si no tiene el subtitulo seleccionado
			IF iSub NOT IN (SELECT idSubtitulo FROM subtitulocontenido WHERE (subtitulocontenido.TiOriginal = NEW.TiOriginal)) THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Idioma de subtitulo no disponible en este título';
			ELSE
				-- Si no tiene wifi y tampoco está en descargas
				IF wifi_ IS NULL AND descargado IS NULL THEN
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No tienes red wifi ni tampoco descargado para reproducir el contenido';
				ELSE
					IF descargado IS NOT NULL AND cal LIKE 'normal' THEN
						SET NEW.IdAudio = 1;
						SET NEW.IdSubtitulo = NULL;
                   			 END IF;
				END IF;
			END IF;
		END IF;
	END IF;
END IF;

END$$

/*
--REPRODUCCION EN CURSO: before delete--------------------------------------------------
- un usuario puede eliminar de la lista de reproduccion en curso pero no de su historial
----------------------------------------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `reproduccionencurso_BEFORE_DELETE` BEFORE DELETE ON `reproduccionencurso` FOR EACH ROW BEGIN
	-- Variables
	DECLARE puntito INT UNSIGNED;
	DECLARE duracioncita INT UNSIGNED;
	
	SELECT PtoSuspenso INTO puntito
	FROM reproduccionencurso
	WHERE reproduccionencurso.PtoSuspenso = OLD.reproduccionencurso.PtoSuspenso;
	
	SELECT duracion INTO duracioncita
	FROM reproduccionencurso INNER JOIN contenido ON reproduccionencurso.TiOriginal = contenido.TiOriginal
	WHERE reproduccionencurso.TiOriginal = OLD.TiOriginal;
	
	
	IF duracioncita >= puntito THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes eliminar tu historial';
	END IF;
END;

/*
--USUARIO: before insert-------
- Máximo 3 usuarios por cuenta
-------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `usuario_BEFORE_INSERT` BEFORE INSERT ON `usuario` FOR EACH ROW BEGIN
   -- Variables
   DECLARE TotalUsuarios INT UNSIGNED;
   DECLARE fechanaci DATE;
    
   SELECT NEW.FechaNac INTO fechanaci;
    
    SELECT SUM(usuario.Email) INTO TotalUsuarios
    FROM usuario 
    WHERE (usuario.Email = NEW.Email)
    GROUP BY Email;
    
    -- Si la FechaNac es inválida
	IF YEAR(fechanaci > CURDATE()) OR YEAR(NEW.FechaNac) < 1910 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fecha de nacimiento invalida';
	-- Si no
   	ELSE
        -- Si hay 3 o más usuarios en un mismo mail
		IF TotalUsuarios >= 3 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya hay 3 usuarios en la cuenta';
		END IF;
	END IF;
    
END$$

/*
--WATCHPARTY: before insert---------------------------
- Si un usuario no pago, no se puede hacer watchparty
- No se puede hacer watchparty consigo mismo
-------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `watchparty_BEFORE_INSERT` BEFORE INSERT ON `watchparty` FOR EACH ROW BEGIN
	-- Variables
	DECLARE user1 VARCHAR(20);
	DECLARE user2 VARCHAR(20);
	DECLARE fechita1 DATE;
	DECLARE fechita2 DATE;
	DECLARE califi VARCHAR(10);
	
	SELECT NEW.UserEmisor INTO user1;
	SELECT New.UserReceptor INTO user2;
	
	-- NIÑOS --
	SELECT FechaNac INTO fechita1
	FROM watchparty INNER JOIN usuario ON watchparty.UserEmisor = usuario.Username
	WHERE usuario.Username = NEW.UserEmisor;
	
	SELECT FechaNac INTO fechita2
	FROM watchparty INNER JOIN usuario ON watchparty.UserReceptor = usuario.Username
	WHERE usuario.Username = NEW.UserReceptor;
		
	SELECT CalifSalida INTO califi
	FROM 
	(
	-- Pelicula
	(SELECT TiOriginal FROM watchparty 
	INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
	INNER JOIN pelicula ON pelicula.TiOriginal = reproduccionencurso.TiOriginal) 
	    
	UNION
	    
	-- Documental
	(SELECT TiOriginal FROM watchparty 
	INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
	INNER JOIN documental ON documental.TiOriginal = reproduccionencurso.TiOriginal) 
	    
	UNION
	    
	-- Serie
	(SELECT NombreSerie AS TiOriginal FROM watchparty 
	INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
	INNER JOIN capitulo ON capitulo.TiOriginal = reproduccionencurso.TiOriginal
	INNER JOIN serie ON serie.NombreSerie = capitulo.NombreSerie) 
	) as e
	WHERE(reproduccionencurso.idReproduccion = NEW.idReproduccion);
	
	IF user1 LIKE user2 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puedes hacer watchparty con vos mismo';
	ELSE
		IF (YEAR(CURDATE()) - YEAR(fechita1) < 13 OR YEAR(CURDATE()) - YEAR(fechita2) < 13) AND califi NOT LIKE 'ATP' THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Restricción de menor de edad aplicada sobre este título';
		END IF;
	END IF;
END$$

/*
--WATCHPARTY: after insert--------------------------------------------------------------
- se debe agregar a la tabla de reproduccionencurso la reproduccion del usuario receptor
----------------------------------------------------------------------------------------
*/
CREATE DEFINER=`root`@`localhost` TRIGGER `watchparty_AFTER_INSERT` AFTER INSERT ON `watchparty` FOR EACH ROW BEGIN
	
	-- Variables
	DECLARE titulo VARCHAR(40);
	DECLARE v FLOAT UNSIGNED;
	DECLARE ps INT UNSIGNED;
	DECLARE fv DATE;
	DECLARE ia VARCHAR(10);
	DECLARE isub VARCHAR(10);
	
	SELECT TiOriginal, Velocidad, PtoSuspenso, FechaVisto, IdiomaAudio, IdiomaSubtitulo INTO titulo, v, ps, fv, ia, isub
	FROM watchparty
	INNER JOIN reproduccionencurso ON watchparty.idReproduccion = reproduccionencurso.idReproduccion
	WHERE(NEW.idReproduccion = watchparty.idReproduccion);
	
	INSERT INTO Reproduccionencurso (TiOriginal, Username, Velocidad, PtoSuspenso, FechaVisto, IdiomaAudio, IdiomaSubtitulo)
	VALUES (titulo, UserReceptor, v, ps, fv, ia, isub);
END;$$

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
