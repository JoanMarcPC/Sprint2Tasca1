-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`proveidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`proveidor` (
  `idproveidor` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NULL DEFAULT NULL,
  `fax` VARCHAR(45) NULL DEFAULT NULL,
  `nif` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`idproveidor`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) VISIBLE,
  INDEX `index_nif` (`nif` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`adress` (
  `idadress` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idproveidor` INT UNSIGNED NOT NULL,
  `carrer` VARCHAR(45) NOT NULL,
  `numero` INT UNSIGNED NULL DEFAULT NULL,
  `pis` TINYINT UNSIGNED NULL DEFAULT NULL,
  `porta` TINYINT UNSIGNED NULL DEFAULT NULL,
  `ciutat` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idadress`),
  INDEX `fk_adress_proveidor1_idx` (`idproveidor` ASC) VISIBLE,
  CONSTRAINT `fk_adress_proveidor1`
    FOREIGN KEY (`idproveidor`)
    REFERENCES `optica`.`proveidor` (`idproveidor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`client` (
  `idclient` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(10) NOT NULL,
  `telefon` VARCHAR(45) NULL,
  `correu` VARCHAR(45) NULL,
  `data_registre` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idclient_recomana` INT NULL COMMENT 'Es guarda el client que li ha recomanat la botiga, si existeix',
  PRIMARY KEY (`idclient`),
  INDEX `fk_client_client1_idx` (`idclient_recomana` ASC) VISIBLE,
  CONSTRAINT `fk_client_client1`
    FOREIGN KEY (`idclient_recomana`)
    REFERENCES `optica`.`client` (`idclient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`marca` (
  `idmarca` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `idproveidor` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idmarca`),
  INDEX `fk_marca_proveidor1_idx` (`idproveidor` ASC) VISIBLE,
  CONSTRAINT `fk_marca_proveidor1`
    FOREIGN KEY (`idproveidor`)
    REFERENCES `optica`.`proveidor` (`idproveidor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`ulleres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`ulleres` (
  `idulleres` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `graduacio_esq` TINYINT UNSIGNED NOT NULL,
  `graduacio_dreta` TINYINT UNSIGNED NOT NULL,
  `muntura` ENUM('flotant', 'pasta', 'metalica') NOT NULL COMMENT 'Possibles valors: flotant, pasta, metalica',
  `color_muntura` VARCHAR(45) NOT NULL,
  `color_vidre_esq` VARCHAR(45) NOT NULL,
  `color_vidre_dreta` VARCHAR(45) NOT NULL,
  `preu` DOUBLE NULL,
  `idmarca` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idulleres`),
  INDEX `fk_ulleres_marca1_idx` (`idmarca` ASC) VISIBLE,
  CONSTRAINT `fk_ulleres_marca1`
    FOREIGN KEY (`idmarca`)
    REFERENCES `optica`.`marca` (`idmarca`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`empleat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`empleat` (
  `idEmpleat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEmpleat`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`comanda` (
  `idcomanda` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idclient` INT NOT NULL,
  `idempleat` INT UNSIGNED NOT NULL,
  `data_compra` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcomanda`),
  INDEX `fk_comanda_client1_idx` (`idclient` ASC) VISIBLE,
  INDEX `fk_comanda_Empleat1_idx` (`idempleat` ASC) VISIBLE,
  CONSTRAINT `fk_comanda_client1`
    FOREIGN KEY (`idclient`)
    REFERENCES `optica`.`client` (`idclient`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comanda_Empleat1`
    FOREIGN KEY (`idempleat`)
    REFERENCES `optica`.`empleat` (`idEmpleat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `optica`.`comanda_te_ulleres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`comanda_te_ulleres` (
  `idcomanda` INT UNSIGNED NOT NULL,
  `dulleres` INT UNSIGNED NOT NULL,
  `quantitat` INT NOT NULL,
  PRIMARY KEY (`idcomanda`, `dulleres`),
  INDEX `fk_comanda_has_ulleres_ulleres1_idx` (`dulleres` ASC) VISIBLE,
  INDEX `fk_comanda_has_ulleres_comanda1_idx` (`idcomanda` ASC) VISIBLE,
  CONSTRAINT `fk_comanda_has_ulleres_comanda1`
    FOREIGN KEY (`idcomanda`)
    REFERENCES `optica`.`comanda` (`idcomanda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comanda_has_ulleres_ulleres1`
    FOREIGN KEY (`dulleres`)
    REFERENCES `optica`.`ulleres` (`idulleres`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
