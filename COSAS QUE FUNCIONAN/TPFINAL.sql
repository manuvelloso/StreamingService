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
  `Tarjeta` VARCHAR(16) NOT NULL,
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
  `Monto` FLOAT UNSIGNED NOT NULL,
  `FechaVTO` DATE NOT NULL,
  `FechaPago` DATE NULL DEFAULT NULL,
  `FormaPago` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`Factura`)descarga,
  INDEX `fk_abono_cuenta` (`Email` ASC) VISIBLE,
  CONSTRAINT `Çonst_abono_formapago` CHECK (FormaPago IN ('Debito en cuenta bancaria','Tarjeta de Credito','Comprobante')),
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
  CONSTRAINT `Const_contenido_genero` CHECK(Genero IN ('Acción y aventuras', 'Animé', 'Comedia', 'Documental', 'Drama', 'Fantasía', 'Terror', 'Extranjera', 'Nacional', 'Familiar', 'Misterio', 'Thriller', 'Romance')),
  CONSTRAINT `Const_contendio_duracion` CHECK(Duracion<270), -- no puede durar + de 4 horas y media
  PRIMARY KEY (`TiOriginal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`actua`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`actua` (
  `idActuacion` INT NOT NULL AUTO_INCREMENT,
  `idActor` INT NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idActuacion`),
  INDEX `fk_actua_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_actua_actor1` (`idActor` ASC) VISIBLE,
  CONSTRAINT `fk_actua_actor1` FOREIGN KEY (`idActor`) REFERENCES `mydb_final`.`actor` (`idActor`)
	ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_actua_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE SET NULL
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
  CONSTRAINT `Const_audio_Audio` CHECK(Audio IN ('original', 'castellano','ingles')),
  PRIMARY KEY (`idAudio`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`audiocontenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`audiocontenido` (
  `idAudioContenido` INT NOT NULL AUTO_INCREMENT,
  `idAudio` INT NOT NULL,
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
  CONSTRAINT `Const_usuario_Email` CHECK (Email LIKE '%@%'),
  PRIMARY KEY (`Username`),
  INDEX `fk_usuario_cuenta1_idx` (`Email` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_cuenta1` FOREIGN KEY (`Email`) REFERENCES `mydb_final`.`cuenta` (`Email`)
	ON DELETE SET NULL
    ON UPDATE CASCADE
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`califica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`califica` (
  `idCalificacion` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Calificacion` VARCHAR(30) NOT NULL,
  `Valor` INT NOT NULL,
  PRIMARY KEY (`idCalificacion`),
  INDEX `fk_califica_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_califica_usuario1` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_califica_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_califica_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
	ON DELETE SET NULL
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
  `AnioLanzamiento` INT NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(20) NULL DEFAULT NULL,
  CONSTRAINT `Cont_serie_CalifSalida` CHECK (CalifSalida IN ('ATP','+13','+16','+18')),
  PRIMARY KEY (`NombreSerie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`capitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`capitulo` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `NombreSerie` VARCHAR(45) NOT NULL,
  `NumCap` INT UNSIGNED NOT NULL,
  `NumTemp` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`TiOriginal`),
  INDEX `fk_capitulo_serie1_idx` (`NombreSerie` ASC) VISIBLE,
  CONSTRAINT `fk_capitulo_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_capitulo_serie1` FOREIGN KEY (`NombreSerie`) REFERENCES `mydb_final`.`serie` (`NombreSerie`)
	ON DELETE SET NULL
    ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`descarga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`descarga` (
  `idDescarga` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Calidad` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idDescarga`),
  INDEX `fk_descarga_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_descarga_usuario1` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_descarga_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_descarga_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `Const_descarga_Calidad` CHECK(Calidad IN ('normal','HD','UHD')) 
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
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`documental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`documental` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Tema` VARCHAR(20) NOT NULL,
  `AnioLanzamiento` INT NOT NULL,
  PRIMARY KEY (`TiOriginal`),
  CONSTRAINT `fk_documental_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE SET NULL
    ON UPDATE CASCADE
  )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`favorito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`favorito` (
  `idFavorito` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idFavorito`),
  INDEX `fk_favorito_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `fk_favorito_usuario1` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_favorito_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
	ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_favorito_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`historial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`historial` (
  `idHistorial` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `FechaVisto` DATE NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  `IdiomaSubtitulo` VARCHAR(20) NULL DEFAULT NULL,
  CONSTRAINT `Const_historial_IdiomaAudio` CHECK(IdiomaAudio IN ('original', 'castellano', 'ingles')),
  CONSTRAINT `Const_historial_IdiomaSubtitulo` CHECK(IdiomaSubtitulo IN (NULL, 'castellano', 'ingles', 'portugues', 'italiano', 'frances')),
  PRIMARY KEY (`idHistorial`),
  INDEX `fk_reproduce_usuario1_idx` (`Username` ASC) VISIBLE,
  INDEX `fk_reproduce_contenido1` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_reproduce_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reproduce_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`pelicula`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`pelicula` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `TiIngles` VARCHAR(45) NOT NULL,
  `TiEspaniol` VARCHAR(45) NOT NULL,
  `AnioLanzamiento` INT NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(10) NOT NULL,
  CONSTRAINT `Const_pelicula_CalifSalida` CHECK(CalifSalida IN ('ATP','+13','+16','+18')),
  PRIMARY KEY (`TiOriginal`),
  CONSTRAINT `fk_pelicula_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`premio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`premio` (
  `idPremio` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Anio` DATE NOT NULL,
  `Categoria` VARCHAR(20) NOT NULL,
  `Festival` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idPremio`),
  INDEX `fk_premio_pelicula1` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_premio_pelicula1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`pelicula` (`TiOriginal`)
	ON DELETE SET NULL
    ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`reproduccionencurso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`reproduccionencurso` (
  `idReproduccion` INT NOT NULL AUTO_INCREMENT,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `Velocidad` FLOAT UNSIGNED NOT NULL,
  `PtoSuspenso` INT UNSIGNED NOT NULL,
  `FechaVisto` DATE NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  `IdiomaSubtitulo` VARCHAR(20) NULL DEFAULT NULL,
  CONSTRAINT `Const_reproduccion_Velocidad` CHECK(Velocidad IN (0.75,1,1.25,1.5)),
  CONSTRAINT `Const_reproduccion_IdiomaAudio` CHECK(IdiomaAudio IN ('original', 'castellano', 'ingles')),
  CONSTRAINT `Const_reproduccion_IdiomaSubtitulo` CHECK(IdiomaSubtitulo IN (NULL, 'castellano', 'ingles', 'portugues', 'italiano', 'frances')),
  PRIMARY KEY (`idReproduccion`),
  INDEX `fk_reproduce_usuario1_idx` (`Username` ASC) VISIBLE,
  INDEX `fk_reproduce_contenido10` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_reproduce_contenido10` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reproduce_usuario10` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`subtitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`subtitulo` (
  `idSubtitulo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `IdiomaSubtitulo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idSubtitulo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`subtitulocontenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`subtitulocontenido` (
  `idSubtituloContenido` INT NOT NULL AUTO_INCREMENT,
  `idSubtitulo` INT UNSIGNED NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idSubtituloContenido`),
  INDEX `fk_subtituloContenido_subtitulo1_idx` (`idSubtitulo` ASC) VISIBLE,
  INDEX `fk_subtituloContenido_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_subtituloContenido_contenido1` FOREIGN KEY (`TiOriginal`) REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_subtituloContenido_subtitulo1` FOREIGN KEY (`idSubtitulo`) REFERENCES `mydb_final`.`subtitulo` (`idSubtitulo`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `mydb_final`.`casting`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`casting` (
  `idCasting` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `DispEmisor` INT UNSIGNED NOT NULL,
  `DispReceptor` INT UNSIGNED NOT NULL,
  CONSTRAINT `Const_casting_disp` CHECK(DispEmisor!=DispReceptor),
  PRIMARY KEY (`idCasting`),
  INDEX `fk_casting_dispositivo1_idx` (`DispEmisor` ASC) VISIBLE,
  INDEX `fk_casting_dispositivo2_idx` (`DispReceptor` ASC) VISIBLE,
  CONSTRAINT `fk_casting_dispositivo1` FOREIGN KEY (`DispEmisor`) REFERENCES `mydb_final`.`dispositivo` (`idDispositivo`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_casting_dispositivo2` FOREIGN KEY (`DispReceptor`) REFERENCES `mydb_final`.`dispositivo` (`idDispositivo`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb_final`.`watchparty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`watchparty` (
  `idWatchparty` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UserEmisor` VARCHAR(20) NOT NULL,
  `UserReceptor` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  CONSTRAINT `Const_watchpary_User` CHECK (UserEmisor != UserReceptor),
  PRIMARY KEY (`idWatchparty`),
  INDEX `fk_watchparty_usuario1_idx` (`UserEmisor` ASC) VISIBLE,
  INDEX `fk_watchparty_usuario2_idx` (`UserReceptor` ASC) VISIBLE,
  CONSTRAINT `fk_watchparty_usuario1` FOREIGN KEY (`UserEmisor`) REFERENCES `mydb_final`.`usuario` (`Username`)
	ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_watchparty_usuario2` FOREIGN KEY (`UserReceptor`) REFERENCES `mydb_final`.`usuario` (`Username`)
	ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb_final`.`busqueda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`busqueda` (
  `idBusqueda` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `Filtro` VARCHAR(15) NOT NULL,
  `Descripcion` VARCHAR(100) NOT NULL,
  CONSTRAINT `Const_buqueda_filtro` CHECK(Filtro IN ('titulo','actor','director','genero','anio de lanzamiento','calificacion de usuarios','historial')),
  PRIMARY KEY (`idBusqueda`),
  INDEX `fk_busqueda_usuario1_idx` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_busqueda_usuario1` FOREIGN KEY (`Username`) REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `mydb_final`;

DELIMITER $$
USE `mydb_final`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb_final`.`abono_BEFORE_INSERT` BEFORE INSERT ON `abono` FOR EACH ROW
BEGIN
    IF DATE_FORMAT(CURDATE(), '%Y-%m')> DATE_FORMAT(CURDATE()-1, '%Y-%m') THEN
		INSERT INTO abono(Email,Monto,FechaVTO,FormaPago)
        VALUES (NEW.Email,NEW.Monto,NEW.FechaVTO,NEW.FormaPago);
    END IF;
END$$

USE `mydb_final`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `mydb_final`.`califica_AFTER_INSERT`
AFTER INSERT ON `mydb_final`.`califica`
FOR EACH ROW
BEGIN
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
    WHERE TiOriginal = NEW.TiOriginal;
END$$

USE `mydb_final`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `mydb_final`.`descarga_BEFORE_INSERT`
BEFORE INSERT ON `mydb_final`.`descarga`
FOR EACH ROW
BEGIN
	DECLARE TotalMins INT UNSIGNED;
    
    SELECT SUM(contenido.Duracion) INTO TotalMins
    FROM descarga 
    INNER JOIN contenido ON descarga.TiOriginal = contenido.TiOriginal
    WHERE descarga.Username = NEW.Username;
    
    IF TotalMins + (SELECT Duracion FROM contenido WHERE TiOriginal = NEW.TiOriginal) > 240 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La descarga supera el límite de 4 horas de contenido.';
    ELSE
		INSERT INTO descarga (Username, TiOriginal, Calidad)
		VALUES (NEW.Username, NEW.TiOriginal, NEW.Calidad);
	END IF;
END$$

USE `mydb_final`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `mydb_final`.`reproduccionencurso_AFTER_UPDATE`
AFTER UPDATE ON `mydb_final`.`reproduccionencurso`
FOR EACH ROW
BEGIN
	DECLARE DurContenido INT UNSIGNED;

    SELECT Duracion INTO DurContenido
    FROM contenido
    WHERE TiOriginal = NEW.TiOriginal;

    IF NEW.PtoSuspenso = DurContenido THEN
    -- Se inserta el registro en la tabla historial 
        INSERT INTO historial (TiOriginal, FechaVisto, Username, IdiomaAudio)
        VALUES (NEW.TiOriginal, NEW.FechaVisto, NEW.Username, NEW.IdiomaAudio);
	
    -- Se saca el registro de la tabla de reproducción
        DELETE FROM reproduccionencurso
        WHERE reproduccionencurso.idReproduccion = NEW.idReproduccion;
    END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
