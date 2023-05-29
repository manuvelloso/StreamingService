-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb_final
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb_final` DEFAULT CHARACTER SET utf8 ;

USE `mydb_final` ;

-- -----------------------------------------------------
-- Table `mydb_final`.`cuenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`cuenta` (
  `Email` VARCHAR(30) NOT NULL,
  `Password` VARCHAR(20) NOT NULL,
  `Tarjeta` VARCHAR(16) NOT NULL,
  `Idioma` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Email`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`abono`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`abono` (
  `Email` VARCHAR(30) NOT NULL,
  `Factura` VARCHAR(45) NOT NULL,
  `Monto` FLOAT UNSIGNED NOT NULL,
  `FechaVTO` DATE NOT NULL,
  `FechaPago` DATE NULL DEFAULT NULL,
  `FormaPago` VARCHAR(45) NULL,
  PRIMARY KEY (`Email`, `Factura`),
  CONSTRAINT `fk_abono_cuenta`
    FOREIGN KEY (`Email`)
    REFERENCES `mydb_final`.`cuenta` (`Email`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    -- CHECK(Email IN (SELECT Email FROM CUENTA))
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`actor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`actor` (
  `idActor` INT NOT NULL,
  `ActNombre` VARCHAR(45) NOT NULL,
  `ActApellido` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idActor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`contenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`contenido` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Duracion` INT UNSIGNED NOT NULL,
  `CalifAverage` FLOAT NULL DEFAULT NULL,
  `idGenero` INT NOT NULL,
  `Director` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`TiOriginal`, `idGenero`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`actua`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`actua` (
  `idActor` INT NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idActor`, `TiOriginal`),
  INDEX `fk_actua_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_actua_actor1`
    FOREIGN KEY (`idActor`)
    REFERENCES `mydb_final`.`actor` (`idActor`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_actua_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    -- CHECK(idActor IN (SELECT idActor FROM ACTOR) AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO)
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`documental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`documental` (
  `idTema` INT NOT NULL,
  `idSubtitulo` INT NOT NULL,
  `idAudio` INT NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `AnioLanzamiento` DATE NOT NULL,
  PRIMARY KEY (`idTema`, `idSubtitulo`, `idAudio`, `TiOriginal`),
  CONSTRAINT `fk_documental_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    
    -- CHECK(TiOriginal IN (SELECT TiOrignal FROM CONTENIDO) 
    --    AND idTema IN (SELECT idTema FROM temaDocumental))
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `mydb_final`.`pelicula`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`pelicula` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `TiIngles` VARCHAR(45) NOT NULL,
  `TiEspaniol` VARCHAR(45) NOT NULL,
  `AnioLanzamiento` DATE NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(10) NOT NULL CHECK(CalifSalida IN ('ATP','+13','+16','+18')),
  `idAudio` INT NOT NULL,
  `idSubtitulo` INT NOT NULL,
  PRIMARY KEY (`TiOriginal`, `idAudio`, `idSubtitulo`),
  CONSTRAINT `fk_pelicula_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `mydb_final`.`serie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`serie` (
  `NombreSerie` VARCHAR(45) NOT NULL,
  `TiEspañol` VARCHAR(45) NOT NULL,
  `TiIngles` VARCHAR(45) NOT NULL,
  `AnioLanzamiento` DATE NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(20) NULL DEFAULT NULL CHECK(CalifSalida IN ('ATP','+13','+16','+18')),
  PRIMARY KEY (`NombreSerie`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`capitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`capitulo` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `NombreSerie` VARCHAR(45) NOT NULL,
  `NumCap` INT UNSIGNED NOT NULL,
  `NumTemp` INT UNSIGNED NOT NULL,
  `idAudio` INT NOT NULL,
  `idSubtitulo` INT NOT NULL,
  PRIMARY KEY (`TiOriginal`, `NombreSerie`, `idAudio`, `idSubtitulo`),
  INDEX `fk_capitulo_serie1_idx` (`NombreSerie` ASC) VISIBLE,
  CONSTRAINT `fk_capitulo_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_capitulo_serie1`
    FOREIGN KEY (`NombreSerie`)
    REFERENCES `mydb_final`.`serie` (`NombreSerie`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    
   -- CHECK(NombreSerie IN (SELECT NombreSerie FROM SERIE) 
   -- AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
    
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`audio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`audio` (
  `idAudio` INT NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idAudio`),
  CONSTRAINT `fk_audio_documental1`
    FOREIGN KEY (`idAudio`)
    REFERENCES `mydb_final`.`documental` (`idAudio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_audio_pelicula1`
    FOREIGN KEY (`idAudio`)
    REFERENCES `mydb_final`.`pelicula` (`idAudio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_audio_capitulo1`
    FOREIGN KEY (`idAudio`)
    REFERENCES `mydb_final`.`capitulo` (`idAudio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`usuario` (
  `Username` VARCHAR(20) NOT NULL,
  `Email` VARCHAR(30) NOT NULL,
  `Telefono` VARCHAR(10) NOT NULL,
  `FechaNac` DATE NOT NULL,
  PRIMARY KEY (`Username`, `Email`),
  INDEX `fk_usuario_cuenta1_idx` (`Email` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_cuenta1`
    FOREIGN KEY (`Email`)
    REFERENCES `mydb_final`.`cuenta` (`Email`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    -- CHECK(Email IN (SELECT Email FROM cuenta))
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`califica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`califica` (
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Calificacion` VARCHAR(10) NOT NULL CHECK(Calificacion IN ('no me gusto','me gusto un poco','no me decido','me gusta bastante','me encanto')),
  PRIMARY KEY (`Username`, `TiOriginal`),
  INDEX `fk_califica_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_califica_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_califica_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    
    -- CHECK(Username IN (SELECT Username FROM USUARIO) 
   --     AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
    
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`descarga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`descarga` (
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `TotalMins` INT UNSIGNED NOT NULL,
  `Calidad` VARCHAR(10) NOT NULL CHECK(Calidad IN ('UHD','HD','normal')),
  PRIMARY KEY (`Username`, `TiOriginal`),
  INDEX `fk_descarga_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_descarga_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_descarga_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    
   -- CHECK(Username IN (SELECT Username FROM USUARIO) 
   --     AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
    
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`dispositivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`dispositivo` (
  `idDispositivo` INT UNSIGNED NOT NULL,
  `Email` VARCHAR(30) NOT NULL,
  `DispNom` VARCHAR(10) NOT NULL,
  `MarcaDisp` VARCHAR(20) NOT NULL,
  `TipoDisp` VARCHAR(10) NOT NULL CHECK(TipoDisp IN ('celular','TV','PC', 'tablet')),
  `ModeloDisp` VARCHAR(10) NOT NULL,
  `RedWifi` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`idDispositivo`, `Email`),
  INDEX `fk_dispositivo_cuenta1_idx` (`Email` ASC) VISIBLE,
  CONSTRAINT `fk_dispositivo_cuenta1`
    FOREIGN KEY (`Email`)
    REFERENCES `mydb_final`.`cuenta` (`Email`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    -- CHECK(ModeloDisp IN (SELECT idModelo FROM MODELO))
    
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`favorito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`favorito` (
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`Username`, `TiOriginal`),
  INDEX `fk_favorito_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_favorito_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_favorito_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    
    --  CHECK(Username IN (SELECT Username FROM USUARIO) 
    --    AND TiOriginal IN (SELECT TiOriginal FROM CONTENIDO))
    
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`premio` 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`premio` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Anio` DATE NOT NULL,
  `Categoria` VARCHAR(20) NOT NULL,
  `Festival` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`TiOriginal`),
  CONSTRAINT `fk_premio_pelicula1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`pelicula` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
    -- CHECK(TiOriginal IN (SELECT TiOriginal FROM PELICULA))
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`reproduce`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`reproduce` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `Velocidad` FLOAT UNSIGNED NOT NULL CHECK(Velocidad IN (0.75,1,1.25,1.5)),
  `PtoSuspenso` INT UNSIGNED NOT NULL,
  `FechaVisto` DATE NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  `IdiomaSubtitulo` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`TiOriginal`, `Username`),
  INDEX `fk_reproduce_usuario1_idx` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_reproduce_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_reproduce_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`subtitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`subtitulo` (
  `idSubtitulo` INT NOT NULL,
  `IdiomaSubtitulo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idSubtitulo`),
  CONSTRAINT `fk_subtitulo_documental1`
    FOREIGN KEY (`idSubtitulo`)
    REFERENCES `mydb_final`.`documental` (`idSubtitulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subtitulo_pelicula1`
    FOREIGN KEY (`idSubtitulo`)
    REFERENCES `mydb_final`.`pelicula` (`idSubtitulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subtitulo_capitulo1`
    FOREIGN KEY (`idSubtitulo`)
    REFERENCES `mydb_final`.`capitulo` (`idSubtitulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`temaDocumental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`temaDocumental` (
  `idTema` INT NOT NULL,
  `Tema` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idTema`),
  CONSTRAINT `fk_temaDocumental_documental1`
    FOREIGN KEY (`idTema`)
    REFERENCES `mydb_final`.`documental` (`idTema`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_final`.`generoContenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`generoContenido` (
  `idGenero` INT NOT NULL,
  `Genero` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idGenero`),
  CONSTRAINT `fk_generoContenido_contenido1`
    FOREIGN KEY (`idGenero`)
    REFERENCES `mydb_final`.`contenido` (`idGenero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;




SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
