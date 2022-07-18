-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`user_premium`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_premium` (
  `iduser_premium` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_creacio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data_renovacio` DATETIME NULL,
  PRIMARY KEY (`iduser_premium`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user` (
  `iduser` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `birth` DATE NOT NULL,
  `sexe` ENUM('H', 'M') NULL,
  `pais` VARCHAR(45) NULL,
  `codi postal` VARCHAR(45) NULL,
  `iduser_premium` INT UNSIGNED NULL,
  PRIMARY KEY (`iduser`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_user_user_premium_idx` (`iduser_premium` ASC) VISIBLE,
  CONSTRAINT `fk_user_user_premium`
    FOREIGN KEY (`iduser_premium`)
    REFERENCES `spotify`.`user_premium` (`iduser_premium`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`targeta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`targeta` (
  `idtargeta` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `num` VARCHAR(45) NOT NULL,
  `mes` VARCHAR(45) NOT NULL,
  `any` VARCHAR(45) NOT NULL,
  `codi` VARCHAR(45) NOT NULL,
  `iduser_premium` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idtargeta`),
  UNIQUE INDEX `num_UNIQUE` (`num` ASC) VISIBLE,
  INDEX `fk_targeta_user_premium1_idx` (`iduser_premium` ASC) VISIBLE,
  CONSTRAINT `fk_targeta_user_premium1`
    FOREIGN KEY (`iduser_premium`)
    REFERENCES `spotify`.`user_premium` (`iduser_premium`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`paypal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`paypal` (
  `idpaypal` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NOT NULL,
  `user_premium_iduser_premium` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idpaypal`),
  UNIQUE INDEX `user_name_UNIQUE` (`user_name` ASC) VISIBLE,
  INDEX `fk_paypal_user_premium1_idx` (`user_premium_iduser_premium` ASC) VISIBLE,
  CONSTRAINT `fk_paypal_user_premium1`
    FOREIGN KEY (`user_premium_iduser_premium`)
    REFERENCES `spotify`.`user_premium` (`iduser_premium`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`pagament`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`pagament` (
  `idpagament` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_premium_iduser_premium` INT UNSIGNED NOT NULL,
  `data` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total` DOUBLE NOT NULL,
  `paypal_idpaypal` INT UNSIGNED NULL,
  `targeta_idtargeta` INT UNSIGNED NULL,
  `tipus` ENUM('T', 'P') NOT NULL COMMENT 'T = targeta\nP= Paypal',
  PRIMARY KEY (`idpagament`),
  INDEX `fk_pagament_user_premium1_idx` (`user_premium_iduser_premium` ASC) VISIBLE,
  INDEX `fk_pagament_paypal1_idx` (`paypal_idpaypal` ASC) VISIBLE,
  INDEX `fk_pagament_targeta1_idx` (`targeta_idtargeta` ASC) VISIBLE,
  CONSTRAINT `fk_pagament_user_premium1`
    FOREIGN KEY (`user_premium_iduser_premium`)
    REFERENCES `spotify`.`user_premium` (`iduser_premium`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagament_paypal1`
    FOREIGN KEY (`paypal_idpaypal`)
    REFERENCES `spotify`.`paypal` (`idpaypal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pagament_targeta1`
    FOREIGN KEY (`targeta_idtargeta`)
    REFERENCES `spotify`.`targeta` (`idtargeta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist` (
  `idplaylist` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_iduser` INT UNSIGNED NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `num_cancons` VARCHAR(45) NOT NULL,
  `data_creacio` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('A', 'E') NOT NULL COMMENT 'A= activa\nE= eliminada',
  `data_eliminada` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`idplaylist`),
  INDEX `fk_playlist_user1_idx` (`user_iduser` ASC) VISIBLE,
  CONSTRAINT `fk_playlist_user1`
    FOREIGN KEY (`user_iduser`)
    REFERENCES `spotify`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artista` (
  `idartista` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `imatge` BLOB NULL,
  PRIMARY KEY (`idartista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`album` (
  `idalbum` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `artista_idartista` INT UNSIGNED NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `any` INT NOT NULL,
  `portada` BLOB NULL,
  PRIMARY KEY (`idalbum`, `artista_idartista`),
  INDEX `fk_album_artista1_idx` (`artista_idartista` ASC) VISIBLE,
  CONSTRAINT `fk_album_artista1`
    FOREIGN KEY (`artista_idartista`)
    REFERENCES `spotify`.`artista` (`idartista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`cancons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`cancons` (
  `idcancons` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `album_idalbum` INT UNSIGNED NOT NULL,
  `durada` INT NOT NULL,
  `reproduccions` INT NULL,
  `titol` VARCHAR(45) NULL,
  PRIMARY KEY (`idcancons`, `album_idalbum`),
  INDEX `fk_cancons_album1_idx` (`album_idalbum` ASC) VISIBLE,
  CONSTRAINT `fk_cancons_album1`
    FOREIGN KEY (`album_idalbum`)
    REFERENCES `spotify`.`album` (`idalbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artista_relacionado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artista_relacionado` (
  `artista_idartista` INT UNSIGNED NOT NULL,
  `artista_idartista1` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`artista_idartista`, `artista_idartista1`),
  INDEX `fk_artista_has_artista_artista2_idx` (`artista_idartista1` ASC) VISIBLE,
  INDEX `fk_artista_has_artista_artista1_idx` (`artista_idartista` ASC) VISIBLE,
  CONSTRAINT `fk_artista_has_artista_artista1`
    FOREIGN KEY (`artista_idartista`)
    REFERENCES `spotify`.`artista` (`idartista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_artista_has_artista_artista2`
    FOREIGN KEY (`artista_idartista1`)
    REFERENCES `spotify`.`artista` (`idartista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_sigue_artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_sigue_artista` (
  `user_iduser` INT UNSIGNED NOT NULL,
  `artista_idartista` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_iduser`, `artista_idartista`),
  INDEX `fk_user_has_artista_artista1_idx` (`artista_idartista` ASC) VISIBLE,
  INDEX `fk_user_has_artista_user1_idx` (`user_iduser` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_artista_user1`
    FOREIGN KEY (`user_iduser`)
    REFERENCES `spotify`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_artista_artista1`
    FOREIGN KEY (`artista_idartista`)
    REFERENCES `spotify`.`artista` (`idartista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_fav_cancons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_fav_cancons` (
  `user_iduser` INT UNSIGNED NOT NULL,
  `cancons_idcancons` INT UNSIGNED NOT NULL,
  `cancons_album_idalbum` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_iduser`, `cancons_idcancons`, `cancons_album_idalbum`),
  INDEX `fk_user_has_cancons_cancons1_idx` (`cancons_idcancons` ASC, `cancons_album_idalbum` ASC) VISIBLE,
  INDEX `fk_user_has_cancons_user1_idx` (`user_iduser` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_cancons_user1`
    FOREIGN KEY (`user_iduser`)
    REFERENCES `spotify`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_cancons_cancons1`
    FOREIGN KEY (`cancons_idcancons` , `cancons_album_idalbum`)
    REFERENCES `spotify`.`cancons` (`idcancons` , `album_idalbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`user_fav_album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`user_fav_album` (
  `user_iduser` INT UNSIGNED NOT NULL,
  `album_idalbum` INT UNSIGNED NOT NULL,
  `album_artista_idartista` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_iduser`, `album_idalbum`, `album_artista_idartista`),
  INDEX `fk_user_has_album_album1_idx` (`album_idalbum` ASC, `album_artista_idartista` ASC) VISIBLE,
  INDEX `fk_user_has_album_user1_idx` (`user_iduser` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_album_user1`
    FOREIGN KEY (`user_iduser`)
    REFERENCES `spotify`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_album_album1`
    FOREIGN KEY (`album_idalbum` , `album_artista_idartista`)
    REFERENCES `spotify`.`album` (`idalbum` , `artista_idartista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist_has_cancons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist_has_cancons` (
  `playlist_idplaylist` INT UNSIGNED NOT NULL,
  `cancons_idcancons` INT UNSIGNED NOT NULL,
  `cancons_album_idalbum` INT UNSIGNED NOT NULL,
  `iduser_add` INT UNSIGNED NOT NULL,
  `data_add` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`playlist_idplaylist`, `cancons_idcancons`, `cancons_album_idalbum`),
  INDEX `fk_playlist_has_cancons_cancons1_idx` (`cancons_idcancons` ASC, `cancons_album_idalbum` ASC) VISIBLE,
  INDEX `fk_playlist_has_cancons_playlist1_idx` (`playlist_idplaylist` ASC) VISIBLE,
  INDEX `fk_playlist_has_cancons_user1_idx` (`iduser_add` ASC) VISIBLE,
  CONSTRAINT `fk_playlist_has_cancons_playlist1`
    FOREIGN KEY (`playlist_idplaylist`)
    REFERENCES `spotify`.`playlist` (`idplaylist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlist_has_cancons_cancons1`
    FOREIGN KEY (`cancons_idcancons` , `cancons_album_idalbum`)
    REFERENCES `spotify`.`cancons` (`idcancons` , `album_idalbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlist_has_cancons_user1`
    FOREIGN KEY (`iduser_add`)
    REFERENCES `spotify`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
