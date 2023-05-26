-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`abono`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`abono` (
  `Factura` VARCHAR(45) NOT NULL,
  `FechaVTO` DATE NOT NULL,
  PRIMARY KEY (`Factura`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`cuenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cuenta` (
  `Email` VARCHAR(30) NOT NULL,
  `Password` VARCHAR(20) NOT NULL,
  `Tarjeta` VARCHAR(16) NOT NULL,
  `Idioma` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Email`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`abona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`abona` (
  `CUENTA_Email` VARCHAR(30) NOT NULL,
  `ABONO_Factura` VARCHAR(45) NOT NULL,
  `monto` FLOAT UNSIGNED NOT NULL,
  `FechaPago` DATE NULL DEFAULT NULL,
  `FormaPago` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CUENTA_Email`, `ABONO_Factura`),
  INDEX `fk_ABONA_CUENTA_idx` (`CUENTA_Email` ASC) VISIBLE,
  INDEX `fk_ABONA_ABONO1_idx` (`ABONO_Factura` ASC) VISIBLE,
  CONSTRAINT `fk_ABONA_ABONO1`
    FOREIGN KEY (`ABONO_Factura`)
    REFERENCES `mydb`.`abono` (`Factura`),
  CONSTRAINT `fk_ABONA_CUENTA`
    FOREIGN KEY (`CUENTA_Email`)
    REFERENCES `mydb`.`cuenta` (`Email`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`actor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`actor` (
  `idActor` INT NOT NULL,
  `ActNombre` VARCHAR(45) NOT NULL,
  `ActApellido` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idActor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`Contenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Contenido` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `CalifAverage` FLOAT NULL,
  `Genero` VARCHAR(20) NULL,
  `Director` VARCHAR(45) NULL,
  `Audio` VARCHAR(15) NULL,
  `Subtitulado` VARCHAR(15) NULL,
  PRIMARY KEY (`TiOriginal`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`actua`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`actua` (
  `ACTOR_idActor` INT NOT NULL,
  `CONTENIDO_TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`ACTOR_idActor`, `CONTENIDO_TiOriginal`),
  INDEX `fk_ACTUA_ACTOR1_idx` (`ACTOR_idActor` ASC) VISIBLE,
  INDEX `CONTENIDO_TiOriginal_idx` (`CONTENIDO_TiOriginal` ASC) VISIBLE,
  CONSTRAINT `ACTOR_idActor`
    FOREIGN KEY (`ACTOR_idActor`)
    REFERENCES `mydb`.`actor` (`idActor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CONTENIDO_TiOriginal`
    FOREIGN KEY (`CONTENIDO_TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`dispositivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dispositivo` (
  `idDispositivo` INT UNSIGNED NOT NULL,
  `DispNom` VARCHAR(10) NOT NULL,
  `MarcaDisp` VARCHAR(20) NOT NULL,
  `TipoDisp` VARCHAR(10) NOT NULL,
  `ModeloDisp` VARCHAR(10) NOT NULL,
  `RedWifi` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`idDispositivo`),
  UNIQUE INDEX `idDispositivo_UNIQUE` (`idDispositivo` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`asocian`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`asocian` (
  `DISPOSITIVO_idDispositivo` INT UNSIGNED NOT NULL,
  `CUENTA_Email` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`DISPOSITIVO_idDispositivo`, `CUENTA_Email`),
  INDEX `fk_ASOCIAN_CUENTA1_idx` (`CUENTA_Email` ASC) VISIBLE,
  CONSTRAINT `fk_ASOCIAN_CUENTA`
    FOREIGN KEY (`CUENTA_Email`)
    REFERENCES `mydb`.`cuenta` (`Email`),
  CONSTRAINT `fk_ASOCIAN_DISPOSITIVO`
    FOREIGN KEY (`DISPOSITIVO_idDispositivo`)
    REFERENCES `mydb`.`dispositivo` (`idDispositivo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`audio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`audio` (
  `TiOriginal` VARCHAR(45) NOT NULL,
  `idAudio` VARCHAR(45) NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  INDEX `TiOriginal_idx` (`TiOriginal` ASC) VISIBLE,
  PRIMARY KEY (`TiOriginal`, `idAudio`),
  INDEX `IdiomaAudio_idx` (`IdiomaAudio` ASC) VISIBLE,
  CONSTRAINT `fk_AUDIO_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`serie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`serie` (
  `TiOriginal` VARCHAR(45) NOT NULL,
  `TiEspañol` VARCHAR(45) NOT NULL,
  `TiIngles` VARCHAR(45) NOT NULL,
  `AnioLanzamiento` DATE NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`TiOriginal`),
  UNIQUE INDEX `TiOriginal_UNIQUE` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_SERIE_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`capitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`capitulo` (
  `SERIE_TiOriginal` VARCHAR(45) NOT NULL,
  `NumCap` INT UNSIGNED NOT NULL,
  `NumTemp` INT UNSIGNED NOT NULL,
  `TiOriginal` VARCHAR(45) NOT NULL,
  `FechaLanzamiento` DATE NOT NULL,
  `Duracion` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`SERIE_TiOriginal`, `NumCap`, `NumTemp`),
  INDEX `fk_CAPITULO_SERIE1_idx` (`SERIE_TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_CAPITULO_SERIE1`
    FOREIGN KEY (`SERIE_TiOriginal`)
    REFERENCES `mydb`.`serie` (`TiOriginal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `Username` VARCHAR(20) NOT NULL,
  `Telefono` VARCHAR(10) NOT NULL,
  `FechaNac` DATE NOT NULL,
  PRIMARY KEY (`Username`),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC) VISIBLE,
  UNIQUE INDEX `Telefono_UNIQUE` (`Telefono` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`contiene`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`contiene` (
  `USUARIO_Username` VARCHAR(20) NOT NULL,
  `CUENTA_Email` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`USUARIO_Username`, `CUENTA_Email`),
  INDEX `fk_CONTIENE_CUENTA1_idx` (`CUENTA_Email` ASC) VISIBLE,
  CONSTRAINT `fk_CONTIENE_CUENTA1`
    FOREIGN KEY (`CUENTA_Email`)
    REFERENCES `mydb`.`cuenta` (`Email`),
  CONSTRAINT `fk_CONTIENE_USUARIO1`
    FOREIGN KEY (`USUARIO_Username`)
    REFERENCES `mydb`.`usuario` (`Username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`documental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`documental` (
  `TiOriginal` VARCHAR(45) NOT NULL,
  `Tema` VARCHAR(20) NOT NULL,
  `Duracion` INT UNSIGNED NOT NULL,
  `AnioLanzamiento` DATE NOT NULL,
  PRIMARY KEY (`TiOriginal`),
  CONSTRAINT `fk_DOCUMENTAL_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`es_dueño`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`es_dueño` (
  `USUARIO_Username` VARCHAR(20) NOT NULL,
  `DISPOSITIVO_idDispositivo` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`USUARIO_Username`, `DISPOSITIVO_idDispositivo`),
  INDEX `fk_ESDUEÑO_DISPOSITIVO1_idx` (`DISPOSITIVO_idDispositivo` ASC) VISIBLE,
  CONSTRAINT `fk_ESDUEÑO_USUARIO1`
    FOREIGN KEY (`USUARIO_Username`)
    REFERENCES `mydb`.`usuario` (`Username`),
  CONSTRAINT `fk_idDisp`
    FOREIGN KEY (`DISPOSITIVO_idDispositivo`)
    REFERENCES `mydb`.`dispositivo` (`idDispositivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`historial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`historial` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `FechaVisto` DATE NOT NULL,
  `Usuario` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TiOriginal`),
  INDEX `idUsuario_idx` (`Usuario` ASC) VISIBLE,
  CONSTRAINT `fk_CONTENIDO_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_idUsuario`
    FOREIGN KEY (`Usuario`)
    REFERENCES `mydb`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`pelicula`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`pelicula` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `TiIngles` VARCHAR(45) NOT NULL,
  `TiEspaniol` VARCHAR(45) NOT NULL,
  `Duracion` INT UNSIGNED NOT NULL,
  `AnioLanzamiento` DATE NOT NULL,
  `Productor` VARCHAR(45) NOT NULL,
  `CalifSalida` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`TiOriginal`),
  UNIQUE INDEX `TiOriginal_UNIQUE` (`TiOriginal` ASC) VISIBLE,
  UNIQUE INDEX `TiIngles_UNIQUE` (`TiIngles` ASC) VISIBLE,
  UNIQUE INDEX `TiEspaniol_UNIQUE` (`TiEspaniol` ASC) VISIBLE,
  CONSTRAINT `fk_PELI_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`premio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`premio` (
  `PELICULA_TiOriginal` VARCHAR(40) NOT NULL,
  `Anio` DATE NOT NULL,
  `Categoria` VARCHAR(20) NOT NULL,
  `Festival` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`PELICULA_TiOriginal`),
  CONSTRAINT `fk_PREMIO_PELICULA1`
    FOREIGN KEY (`PELICULA_TiOriginal`)
    REFERENCES `mydb`.`pelicula` (`TiOriginal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`watchparty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`watchparty` (
  `Autorizacion` TINYINT NOT NULL,
  `USUARIO_Username` VARCHAR(20) NOT NULL,
  `USUARIO_Username1` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`USUARIO_Username`, `USUARIO_Username1`),
  INDEX `fk_WATCHPARTY_USUARIO2_idx` (`USUARIO_Username1` ASC) VISIBLE,
  CONSTRAINT `fk_WATCHPARTY_USUARIO1`
    FOREIGN KEY (`USUARIO_Username`)
    REFERENCES `mydb`.`usuario` (`Username`),
  CONSTRAINT `fk_WATCHPARTY_USUARIO2`
    FOREIGN KEY (`USUARIO_Username1`)
    REFERENCES `mydb`.`usuario` (`Username`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`Subtitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Subtitulo` (
  `idSubtitulo` INT NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Sub` VARCHAR(20) NULL,
  PRIMARY KEY (`idSubtitulo`, `TiOriginal`),
  INDEX `TiOriginal_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `IdiomaSub` (`Sub` ASC) VISIBLE,
  CONSTRAINT `fk_SUB_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`REPRODUCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`REPRODUCE` (
  `Usuario` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(45) NOT NULL,
  `Velocidad` FLOAT NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  `IdiomaSub` VARCHAR(45) NULL,
  `pto_suspenso` TIME NULL,
  PRIMARY KEY (`Usuario`, `TiOriginal`),
  INDEX `TiOriginal_idx` (`TiOriginal` ASC) VISIBLE,
  INDEX `IdiomaAudio_idx` (`IdiomaAudio` ASC) VISIBLE,
  INDEX `IdiomaSub_idx` (`IdiomaSub` ASC) VISIBLE,
  CONSTRAINT `fk_REP_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REP_IdiomaAudio`
    FOREIGN KEY (`IdiomaAudio`)
    REFERENCES `mydb`.`audio` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REP_IdiomaSub`
    FOREIGN KEY (`IdiomaSub`)
    REFERENCES `mydb`.`Subtitulo` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REP_Usuario`
    FOREIGN KEY (`Usuario`)
    REFERENCES `mydb`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DESCARGA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DESCARGA` (
  `Usuario` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `total_mins` INT NOT NULL,
  `Calidad` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Usuario`, `TiOriginal`),
  INDEX `TiOriginal_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_DESCARGA_Usuario`
    FOREIGN KEY (`Usuario`)
    REFERENCES `mydb`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DESCARGA_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`FAVORITO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FAVORITO` (
  `Usuario` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`Usuario`, `TiOriginal`),
  INDEX `TiOriginal_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_FAV_Usuario`
    FOREIGN KEY (`Usuario`)
    REFERENCES `mydb`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FAV_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CALIFICA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CALIFICA` (
  `Usuario` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `CalPersonal` INT NOT NULL,
  PRIMARY KEY (`Usuario`, `TiOriginal`),
  INDEX `TiOriginal_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_CAL_Usuario`
    FOREIGN KEY (`Usuario`)
    REFERENCES `mydb`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CAL_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PERMITE_VER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PERMITE_VER` (
  `TiOriginal` VARCHAR(20) NOT NULL,
  `idDisp` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`TiOriginal`, `idDisp`),
  INDEX `idDisp_idx` (`idDisp` ASC) VISIBLE,
  CONSTRAINT `fk_PERMITE_idDisp`
    FOREIGN KEY (`idDisp`)
    REFERENCES `mydb`.`dispositivo` (`idDispositivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PERMITE_TiOriginal`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb`.`Contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
