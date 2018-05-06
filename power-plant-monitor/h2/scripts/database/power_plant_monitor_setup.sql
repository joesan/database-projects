--
-- setup.sql
--
-- This file is part of 
--   - http://github.com/joesan/plant-monitor
--
-- Copyright (c) 2017 joesan @ http://github.com/joesan
--  
-- DISCLAIMER
--  To the best of my knowledge, this data is fabricated, and
--  it does not correspond to real people or any real organization. 
--  Any similarity to existing people is purely coincidental.

DROP TABLE IF EXISTS user,
                     powerplant,
                     chronometer,
                     tenant;

CREATE TABLE tenant (
    tenantId   INT             NOT NULL,
    tenantName VARCHAR(25)     NOT NULL,
    street     VARCHAR(20)     NOT NULL,
    city       VARCHAR(20)     NOT NULL,
    country    VARCHAR(20)     NOT NULL, 
    createdAt  TIMESTAMP       NOT NULL,
    updatedAt  TIMESTAMP       NOT NULL,   
    PRIMARY KEY (tetantId)
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
    tetantId         INT         NOT NULL,
    isActive         BOOL        NOT NULL,
    minPower         INT         NOT NULL,
    maxPower         INT         NOT NULL,
    rampRate         INT,
    rampRateSecs     INT,
    powerPlantType   VARCHAR(25) check (powerPlantType in ('OnOffType', 'RampUpType')),
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

-- Insert some data
INSERT INTO `tenant` VALUES 
(1, 'Organization-001', 'street-001', 'city-001', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(2, 'Organization-002', 'street-002', 'city-002', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(3, 'Organization-003', 'street-003', 'city-003', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(4, 'Organization-004', 'street-004', 'city-004', 'Germany', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

INSERT INTO `powerPlant` VALUES 
(1, 1, true,  20,  100, NULL, NULL, 'OnOffType',  CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(2, 1, true,  100, 800, 100,  2,    'RampUpType', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(3, 2, true,  200, 400, 50,   2,    'RampUpType', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(4, 2, true,  200, 400, 50,   2,    'RampUpType', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(5, 3, false, 200, 600, NULL, NULL, 'OnOffType',  CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(6, 3, true,  400, 800, NULL, NULL, 'OnOffType',  CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(7, 4, true,  100, 800, 100,  4,    'RampUpType', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(8, 4, false, 100, 900, NULL, NULL, 'OnOffType',  CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

INSERT INTO `user` VALUES 
(1, 1, 'user', 'joe', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
(2, 2, 'user', 'san', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());
