--
-- setup.sql
--
-- This file is part of 
--   - http://github.com/joesan/plant-simulator
--
-- Copyright (c) 2017 joesan @ http://github.com/joesan
--  
-- DISCLAIMER
--  To the best of my knowledge, this data is fabricated, and
--  it does not correspond to real people or any real organization. 
--  Any similarity to existing people is purely coincidental.

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

DROP TABLE IF EXISTS user,
                     powerPlant,
                     chronometer,
                     tenant;

/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE tenant (
    tenantId      INT             NOT NULL,
    tenantName    VARCHAR(25)     NOT NULL,
    street        VARCHAR(20)     NOT NULL,
    city          VARCHAR(20)     NOT NULL,
    country       VARCHAR(20)     NOT NULL, 
    createdAt     TIMESTAMP       NOT NULL,
    updatedAt     TIMESTAMP       NOT NULL,   
    PRIMARY KEY (tenentId)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE chronometer (
    id         INT        NOT NULL,
    tenantId   INT        NOT NULL,
    lastUpdate TIMESTAMP  NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (tenantId) REFERENCES tenant (tenantId) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE powerplant (
    powerPlantId     INT         NOT NULL,
    tenantId         INT         NOT NULL,
    isActive         BOOL        NOT NULL,
    minPower         INT         NOT NULL,
    maxPower         INT         NOT NULL,
    rampRate         INT,
    rampRateSecs     INT,
    powerPlantType   ENUM        ('OnOffType', 'RampUpType'),
    createdAt        TIMESTAMP   NOT NULL,
    updatedAt        TIMESTAMP   NOT NULL,
    PRIMARY KEY (powerPlantId),
    FOREIGN KEY (tenantId) REFERENCES tenant (tenantId) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE user (
    userId       INT             NOT NULL,
    tenantId     INT             NOT NULL,
    firstName    VARCHAR(30)     NOT NULL,
    lastName     VARCHAR(30)     NOT NULL,
    createdAt    TIMESTAMP       NOT NULL,
    updatedAt    TIMESTAMP       NOT NULL, 
    PRIMARY KEY (userId),
    FOREIGN KEY (tenantId) REFERENCES tenant (tenantId) ON DELETE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- Insert some data
SELECT 'LOADING tenant' as 'INFO';
INSERT INTO `tenant` VALUES 
('Organization-001', 'street-001', 'city-001', 'Germany', TIMESTAMP('2017-08-10'), TIMESTAMP('2017-08-10')),
('Organization-002', 'street-002', 'city-002', 'Germany', TIMESTAMP('2017-08-10'), TIMESTAMP('2017-08-10')),
('Organization-003', 'street-003', 'city-003', 'Germany', TIMESTAMP('2017-08-10'), TIMESTAMP('2017-08-10')),
('Organization-004', 'street-004', 'city-004', 'Germany', TIMESTAMP('2017-08-10'), TIMESTAMP('2017-08-10'));

SELECT 'LOADING powerplant' as 'INFO';
INSERT INTO `powerplant` VALUES 
('1', 'Organization-001', true,  20,  100, NULL, NULL, 'OnOffType',  TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
('2', 'Organization-001', true,  100, 800, 100,  2,    'RampUpType', TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
('3', 'Organization-002', true,  200, 400, 50,   2,    'RampUpType', TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
('4', 'Organization-002', true,  200, 400, 50,   2,    'RampUpType', TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
('5', 'Organization-003', false, 200, 600, NULL, NULL, 'OnOffType',  TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
('6', 'Organization-003', true,  400, 800, NULL, NULL, 'OnOffType',  TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
('7', 'Organization-004', true,  100, 800, 100,  4,    'RampUpType', TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
('8', 'Organization-004', false, 100, 900, NULL, NULL, 'OnOffType',  TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10'));

SELECT 'LOADING user' as 'INFO';
INSERT INTO `user` VALUES 
(1, 'Organization-001', 'user', 'joe', TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10')),
(2, 'Organization-002', 'user', 'san', TIMESTAMP('2017-08-10'),  TIMESTAMP('2017-08-10'));
