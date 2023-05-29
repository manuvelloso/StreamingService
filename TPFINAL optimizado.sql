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
  PRIMARY KEY (`Factura`),
  CONSTRAINT `fk_abono_cuenta`
    FOREIGN KEY (`Email`)
    REFERENCES `mydb_final`.`cuenta` (`Email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
  `idGenero` INT NOT NULL,
  `Director` VARCHAR(45) NOT NULL,
  `CalifAverage` FLOAT NULL,
  PRIMARY KEY (`TiOriginal`),
  INDEX `idx_idGenero` (`idGenero` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`actua`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`actua` (
  `idActuacion` INT NOT NULL AUTO_INCREMENT,
  `idActor` INT NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  INDEX `fk_actua_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  PRIMARY KEY (`idActuacion`),
  CONSTRAINT `fk_actua_actor1`
    FOREIGN KEY (`idActor`)
    REFERENCES `mydb_final`.`actor` (`idActor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_actua_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
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
  PRIMARY KEY (`Username`),
  INDEX `fk_usuario_cuenta1_idx` (`Email` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_cuenta1`
    FOREIGN KEY (`Email`)
    REFERENCES `mydb_final`.`cuenta` (`Email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`califica`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`califica` (
  `idCalificacion` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Calificacion` VARCHAR(10) NOT NULL,
  INDEX `fk_califica_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  PRIMARY KEY (`idCalificacion`),
  CONSTRAINT `fk_califica_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_califica_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
  `CalifSalida` VARCHAR(20) NULL DEFAULT NULL,
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
  PRIMARY KEY (`TiOriginal`),
  INDEX `fk_capitulo_serie1_idx` (`NombreSerie` ASC) VISIBLE,
  CONSTRAINT `fk_capitulo_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_capitulo_serie1`
    FOREIGN KEY (`NombreSerie`)
    REFERENCES `mydb_final`.`serie` (`NombreSerie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`descarga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`descarga` (
  `idDescarga` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Duracion` INT UNSIGNED NOT NULL,
  `Calidad` VARCHAR(10) NOT NULL,
  INDEX `fk_descarga_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  PRIMARY KEY (`idDescarga`),
  CONSTRAINT `fk_descarga_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_descarga_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`dispositivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`dispositivo` (
  `idDispositivo` INT UNSIGNED NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `DispNom` VARCHAR(10) NOT NULL,
  `MarcaDisp` VARCHAR(20) NOT NULL,
  `TipoDisp` VARCHAR(10) NOT NULL,
  `ModeloDisp` VARCHAR(10) NOT NULL,
  `RedWifi` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`idDispositivo`),
  INDEX `fk_dispositivo_usuario1_idx` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_dispositivo_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`documental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`documental` (
  `TiOriginal` VARCHAR(40) NOT NULL,
  `idTema` INT NOT NULL,
  `AnioLanzamiento` DATE NOT NULL,
  PRIMARY KEY (`TiOriginal`),
  INDEX `idx_idTema` (`idTema` ASC) VISIBLE,
  CONSTRAINT `fk_documental_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`favorito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`favorito` (
  `idFavorito` INT NOT NULL AUTO_INCREMENT,
  `Username` VARCHAR(20) NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idFavorito`),
  INDEX `fk_favorito_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_favorito_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_favorito_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
  `CalifSalida` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`TiOriginal`),
  CONSTRAINT `fk_pelicula_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`premio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`premio` (
  `idPremio` INT NOT NULL AUTO_INCREMENT,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Anio` DATE NOT NULL,
  `Categoria` VARCHAR(20) NOT NULL,
  `Festival` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idPremio`),
  CONSTRAINT `fk_premio_pelicula1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`pelicula` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`historial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`historial` (
  `idHistorial` INT NOT NULL AUTO_INCREMENT,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `FechaVisto` DATE NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  `IdiomaSubtitulo` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`idHistorial`),
  INDEX `fk_reproduce_usuario1_idx` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_reproduce_usuario1`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reproduce_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`subtitulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`subtitulo` (
  `idSubtitulo` INT NOT NULL,
  `IdiomaSubtitulo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idSubtitulo`))
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


-- -----------------------------------------------------
-- Table `mydb_final`.`audio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`audio` (
  `idAudio` INT NOT NULL,
  `Audio` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idAudio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_final`.`audioContenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`audioContenido` (
  `idAudioContenido` INT NOT NULL AUTO_INCREMENT,
  `idAudio` INT NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idAudioContenido`),
  INDEX `fk_audioContenido_Audio1_idx` (`idAudio` ASC) VISIBLE,
  INDEX `fk_audioContenido_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_audioContenido_Audio1`
    FOREIGN KEY (`idAudio`)
    REFERENCES `mydb_final`.`audio` (`idAudio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_audioContenido_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb_final`.`subtituloContenido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`subtituloContenido` (
  `idSubtituloContenido` INT NOT NULL AUTO_INCREMENT,
  `idSubtitulo` INT NOT NULL,
  `TiOriginal` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`idSubtituloContenido`),
  INDEX `fk_subtituloContenido_subtitulo1_idx` (`idSubtitulo` ASC) VISIBLE,
  INDEX `fk_subtituloContenido_contenido1_idx` (`TiOriginal` ASC) VISIBLE,
  CONSTRAINT `fk_subtituloContenido_subtitulo1`
    FOREIGN KEY (`idSubtitulo`)
    REFERENCES `mydb_final`.`subtitulo` (`idSubtitulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subtituloContenido_contenido1`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb_final`.`reproduccionEnCurso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_final`.`reproduccionEnCurso` (
  `idReproduccion` INT NOT NULL AUTO_INCREMENT,
  `TiOriginal` VARCHAR(40) NOT NULL,
  `Username` VARCHAR(20) NOT NULL,
  `Velocidad` FLOAT UNSIGNED NOT NULL,
  `PtoSuspenso` INT UNSIGNED NOT NULL,
  `FechaVisto` DATE NOT NULL,
  `IdiomaAudio` VARCHAR(20) NOT NULL,
  `IdiomaSubtitulo` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`idReproduccion`),
  INDEX `fk_reproduce_usuario1_idx` (`Username` ASC) VISIBLE,
  CONSTRAINT `fk_reproduce_usuario10`
    FOREIGN KEY (`Username`)
    REFERENCES `mydb_final`.`usuario` (`Username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reproduce_contenido10`
    FOREIGN KEY (`TiOriginal`)
    REFERENCES `mydb_final`.`contenido` (`TiOriginal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
