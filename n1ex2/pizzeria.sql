-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`provincia` (
  `idprovincia` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idprovincia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`localitat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`localitat` (
  `idlocalitat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idprovincia` INT UNSIGNED NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idlocalitat`, `idprovincia`),
  INDEX `fk_localitat_provincia_idx` (`idprovincia` ASC) VISIBLE,
  CONSTRAINT `fk_localitat_provincia`
    FOREIGN KEY (`idprovincia`)
    REFERENCES `pizzeria`.`provincia` (`idprovincia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`clients` (
  `idclients` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognoms` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(10) NULL,
  `telefon` VARCHAR(45) NOT NULL,
  `idlocalitat` INT UNSIGNED NOT NULL,
  `idprovincia` INT UNSIGNED NOT NULL COMMENT 'tingues en compte que prové de la taula localitat i no de la taula provincia',
  PRIMARY KEY (`idclients`),
  INDEX `fk_clients_localitat1_idx` (`idlocalitat` ASC, `idprovincia` ASC) VISIBLE,
  INDEX `nom_cognoms` (`nom` ASC, `cognoms` ASC) VISIBLE,
  CONSTRAINT `fk_clients_localitat1`
    FOREIGN KEY (`idlocalitat` , `idprovincia`)
    REFERENCES `pizzeria`.`localitat` (`idlocalitat` , `idprovincia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`botiga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`botiga` (
  `idbotiga` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idlocalitat` INT UNSIGNED NOT NULL,
  `idprovincia` INT UNSIGNED NOT NULL COMMENT 'S\'ha de tenir en compte que prové de la taula localitat\n',
  `adress` VARCHAR(45) NOT NULL,
  `codi_postal` VARCHAR(10) NULL,
  PRIMARY KEY (`idbotiga`),
  INDEX `fk_botiga_localitat1_idx` (`idlocalitat` ASC, `idprovincia` ASC) VISIBLE,
  CONSTRAINT `fk_botiga_localitat1`
    FOREIGN KEY (`idlocalitat` , `idprovincia`)
    REFERENCES `pizzeria`.`localitat` (`idlocalitat` , `idprovincia`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`empleat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`empleat` (
  `idempleat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idbotiga` INT UNSIGNED NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `cognoms` VARCHAR(45) NOT NULL,
  `nif` VARCHAR(9) NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  `tipo` ENUM('D', 'C') NOT NULL COMMENT 'D= repartidor delivery\nC = cocinero',
  PRIMARY KEY (`idempleat`),
  UNIQUE INDEX `nif_UNIQUE` (`nif` ASC) VISIBLE,
  INDEX `fk_empleat_botiga1_idx` (`idbotiga` ASC) VISIBLE,
  INDEX `nif` (`nif` ASC) VISIBLE,
  CONSTRAINT `fk_empleat_botiga1`
    FOREIGN KEY (`idbotiga`)
    REFERENCES `pizzeria`.`botiga` (`idbotiga`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comanda` (
  `idcomanda` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idclients` INT UNSIGNED NOT NULL,
  `idempleat` INT UNSIGNED NOT NULL,
  `idbotiga` INT UNSIGNED NOT NULL,
  `data` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tipo` ENUM('D', 'R') NULL COMMENT 'D = delivery\nR = ',
  `preuTotal` DOUBLE NULL,
  PRIMARY KEY (`idcomanda`),
  INDEX `fk_comanda_clients1_idx` (`idclients` ASC) VISIBLE,
  INDEX `fk_comanda_empleat1_idx` (`idempleat` ASC) VISIBLE,
  INDEX `fk_comanda_botiga1_idx` (`idbotiga` ASC) VISIBLE,
  CONSTRAINT `fk_comanda_clients1`
    FOREIGN KEY (`idclients`)
    REFERENCES `pizzeria`.`clients` (`idclients`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comanda_empleat1`
    FOREIGN KEY (`idempleat`)
    REFERENCES `pizzeria`.`empleat` (`idempleat`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comanda_botiga1`
    FOREIGN KEY (`idbotiga`)
    REFERENCES `pizzeria`.`botiga` (`idbotiga`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categoria` (
  `idcategoria` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idcategoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`producte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`producte` (
  `idproducte` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idcategoria` INT UNSIGNED NULL COMMENT 'Solo habrá valor si el',
  `nom` VARCHAR(45) NOT NULL,
  `descripcio` VARCHAR(100) NULL,
  `imatge` BLOB NULL,
  `preu` DOUBLE UNSIGNED NOT NULL,
  `tipus` ENUM('P', 'H', 'B') NOT NULL COMMENT 'P = pìzza (s\'ha d\'omplir el camp categoria)\nH = hamburguesa\nB = beguda',
  PRIMARY KEY (`idproducte`),
  INDEX `fk_producte_categoria1_idx` (`idcategoria` ASC) VISIBLE,
  CONSTRAINT `fk_producte_categoria1`
    FOREIGN KEY (`idcategoria`)
    REFERENCES `pizzeria`.`categoria` (`idcategoria`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`comanda_te_productes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`comanda_te_productes` (
  `idproducte` INT UNSIGNED NOT NULL,
  `idcomanda` INT UNSIGNED NOT NULL,
  `quantitat` INT NULL,
  PRIMARY KEY (`idproducte`, `idcomanda`),
  INDEX `fk_producte_has_comanda_comanda1_idx` (`idcomanda` ASC) VISIBLE,
  INDEX `fk_producte_has_comanda_producte1_idx` (`idproducte` ASC) VISIBLE,
  CONSTRAINT `fk_producte_has_comanda_producte1`
    FOREIGN KEY (`idproducte`)
    REFERENCES `pizzeria`.`producte` (`idproducte`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_producte_has_comanda_comanda1`
    FOREIGN KEY (`idcomanda`)
    REFERENCES `pizzeria`.`comanda` (`idcomanda`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
