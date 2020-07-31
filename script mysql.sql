//------------------Table coutryandcity--------------------//

CREATE TABLE IF NOT EXISTS `CountriesAndCitiesOfTheWorld`.`coutryandcity` (
  `coutryandcityid` INT UNSIGNED NOT NULL,
  `countryid` INT UNSIGNED NOT NULL,
  `regionid` INT UNSIGNED NOT NULL,
  `districtid` INT UNSIGNED NULL,
  `cityid` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`coutryandcityid`),
  INDEX `fk_countryid_idx` (`countryid` ASC) VISIBLE,
  INDEX `fk_regionid_idx` (`regionid` ASC) VISIBLE,
  INDEX `fk_districtid_idx` (`districtid` ASC) VISIBLE,
  INDEX `fk_cityid_idx` (`cityid` ASC) VISIBLE,
  UNIQUE INDEX `crdc` (`countryid` ASC, `regionid` ASC, `districtid` ASC, `cityid` ASC) VISIBLE,
  CONSTRAINT `fk_cityid`
    FOREIGN KEY (`cityid`)
    REFERENCES `CountriesAndCitiesOfTheWorld`.`city` (`cityid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_countryid`
    FOREIGN KEY (`countryid`)
    REFERENCES `CountriesAndCitiesOfTheWorld`.`country` (`countryid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_regionid`
    FOREIGN KEY (`regionid`)
    REFERENCES `CountriesAndCitiesOfTheWorld`.`region` (`regionid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_districtid`
    FOREIGN KEY (`districtid`)
    REFERENCES `CountriesAndCitiesOfTheWorld`.`district` (`districtid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB



//------------------Table country--------------------//

CREATE TABLE IF NOT EXISTS `CountriesAndCitiesOfTheWorld`.`country` (
  `countryid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `countryname` VARCHAR(70) NOT NULL,
  PRIMARY KEY (`countryid`),
  UNIQUE INDEX `countryname_UNIQUE` (`countryname` ASC) VISIBLE)
ENGINE = InnoDB



//------------------Table region--------------------//

CREATE TABLE IF NOT EXISTS `CountriesAndCitiesOfTheWorld`.`region` (
  `regionid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `regionname` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`regionid`),
  UNIQUE INDEX `regionname_UNIQUE` (`regionname` ASC) VISIBLE)
ENGINE = InnoDB



//------------------Table district--------------------//

CREATE TABLE IF NOT EXISTS `CountriesAndCitiesOfTheWorld`.`district` (
  `districtid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `districtname` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`districtid`),
  UNIQUE INDEX `districtname_UNIQUE` (`districtname` ASC) VISIBLE)
ENGINE = InnoDB



//------------------Table city--------------------//

CREATE TABLE IF NOT EXISTS `CountriesAndCitiesOfTheWorld`.`city` (
  `cityid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cityname` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`cityid`),
  UNIQUE INDEX `cityname_UNIQUE` (`cityname` ASC) VISIBLE)
ENGINE = InnoDB
