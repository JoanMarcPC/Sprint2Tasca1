-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema youtube
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `youtube` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci ;
USE `youtube` ;

-- -----------------------------------------------------
-- Table `youtube`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`user` (
  `iduser` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NULL,
  `birth` DATE NOT NULL,
  `sexe` ENUM('H', 'D') NOT NULL COMMENT 'D = dona\nH=home',
  `pais` VARCHAR(45) NULL,
  `codi_postal` VARCHAR(10) NULL,
  PRIMARY KEY (`iduser`),
  UNIQUE INDEX `nom_UNIQUE` (`nom` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`canal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`canal` (
  `idcanal` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `iduser` INT UNSIGNED NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `data_creacio` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `descripcio` VARCHAR(45) NULL,
  PRIMARY KEY (`idcanal`),
  INDEX `fk_canal_user1_idx` (`iduser` ASC) VISIBLE,
  CONSTRAINT `fk_canal_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `youtube`.`user` (`iduser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`video` (
  `idvideo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `iduser` INT UNSIGNED NOT NULL,
  `idcanal` INT UNSIGNED NOT NULL,
  `titol` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(45) NOT NULL,
  `size` DOUBLE NOT NULL,
  `durada` INT NOT NULL,
  `nom_arxiu` VARCHAR(45) NOT NULL,
  `status` ENUM('Public', 'Ocult', 'Privat') NOT NULL,
  `data_creacio` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `thumbnail` BLOB NULL,
  `num_reproduccions` INT NULL,
  `num_like` INT NULL,
  `num_dislike` INT NULL,
  PRIMARY KEY (`idvideo`),
  INDEX `fk_video_user1_idx` (`iduser` ASC) VISIBLE,
  INDEX `fk_video_canal1_idx` (`idcanal` ASC) VISIBLE,
  CONSTRAINT `fk_video_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `youtube`.`user` (`iduser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_video_canal1`
    FOREIGN KEY (`idcanal`)
    REFERENCES `youtube`.`canal` (`idcanal`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`user_suscribe_canal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`user_suscribe_canal` (
  `user_iduser` INT UNSIGNED NOT NULL,
  `canal_idcanal` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_iduser`, `canal_idcanal`),
  INDEX `fk_user_has_canal_canal1_idx` (`canal_idcanal` ASC) VISIBLE,
  INDEX `fk_user_has_canal_user1_idx` (`user_iduser` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_canal_user1`
    FOREIGN KEY (`user_iduser`)
    REFERENCES `youtube`.`user` (`iduser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_has_canal_canal1`
    FOREIGN KEY (`canal_idcanal`)
    REFERENCES `youtube`.`canal` (`idcanal`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`comentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`comentari` (
  `idcomentari` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `iduser` INT UNSIGNED NOT NULL,
  `idvideo` INT UNSIGNED NOT NULL,
  `text` VARCHAR(200) NOT NULL,
  `data_creacio` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcomentari`),
  INDEX `fk_comentari_user1_idx` (`iduser` ASC) VISIBLE,
  INDEX `fk_comentari_video1_idx` (`idvideo` ASC) VISIBLE,
  CONSTRAINT `fk_comentari_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `youtube`.`user` (`iduser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comentari_video1`
    FOREIGN KEY (`idvideo`)
    REFERENCES `youtube`.`video` (`idvideo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`like_dislike`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`like_dislike` (
  `idlike` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `iduser` INT UNSIGNED NOT NULL,
  `idcomentari` INT UNSIGNED NULL COMMENT 'NULL si id_video IS NOT NULL',
  `idvideo` INT UNSIGNED NULL COMMENT 'NULL si id_comentari IS NOT NULL',
  `data_creacio` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo` ENUM('L', 'D') NOT NULL,
  PRIMARY KEY (`idlike`),
  INDEX `fk_like_dislike_user1_idx` (`iduser` ASC) VISIBLE,
  INDEX `fk_like_dislike_comentari1_idx` (`idcomentari` ASC) VISIBLE,
  INDEX `fk_like_dislike_video1_idx` (`idvideo` ASC) VISIBLE,
  CONSTRAINT `fk_like_dislike_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `youtube`.`user` (`iduser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_like_dislike_comentari1`
    FOREIGN KEY (`idcomentari`)
    REFERENCES `youtube`.`comentari` (`idcomentari`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_like_dislike_video1`
    FOREIGN KEY (`idvideo`)
    REFERENCES `youtube`.`video` (`idvideo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlist` (
  `idplaylist` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `iduser` INT UNSIGNED NOT NULL COMMENT 'id de l\'usuari que ha creat la playlist',
  `nom` VARCHAR(45) NULL,
  `data_creacio` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('Public', 'Privat') NULL,
  PRIMARY KEY (`idplaylist`),
  INDEX `fk_playlist_user1_idx` (`iduser` ASC) VISIBLE,
  CONSTRAINT `fk_playlist_user1`
    FOREIGN KEY (`iduser`)
    REFERENCES `youtube`.`user` (`iduser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`playlist_te_video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`playlist_te_video` (
  `idplaylist` INT UNSIGNED NOT NULL,
  `idvideo` INT UNSIGNED NOT NULL,
  `iduser_addVideo` INT UNSIGNED NOT NULL COMMENT 'id de l\'usuari que ha afegit un video a una playlist',
  `data_add` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idplaylist`, `idvideo`),
  INDEX `fk_playlist_has_video_video1_idx` (`idvideo` ASC) VISIBLE,
  INDEX `fk_playlist_has_video_playlist1_idx` (`idplaylist` ASC) VISIBLE,
  INDEX `fk_playlist_te_video_user1_idx` (`iduser_addVideo` ASC) VISIBLE,
  CONSTRAINT `fk_playlist_has_video_playlist1`
    FOREIGN KEY (`idplaylist`)
    REFERENCES `youtube`.`playlist` (`idplaylist`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_playlist_has_video_video1`
    FOREIGN KEY (`idvideo`)
    REFERENCES `youtube`.`video` (`idvideo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_playlist_te_video_user1`
    FOREIGN KEY (`iduser_addVideo`)
    REFERENCES `youtube`.`user` (`iduser`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `youtube`.`etiqueta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `youtube`.`etiqueta` (
  `idetiqueta` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idvideo` INT UNSIGNED NULL,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idetiqueta`),
  INDEX `fk_etiqueta_video1_idx` (`idvideo` ASC) VISIBLE,
  CONSTRAINT `fk_etiqueta_video1`
    FOREIGN KEY (`idvideo`)
    REFERENCES `youtube`.`video` (`idvideo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
