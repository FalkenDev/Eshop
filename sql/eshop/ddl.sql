-- DROP DATABASE IF EXISTS eshop;
-- CREATE DATABASE eshop;

 
DROP TABLE IF EXISTS kategorisering;
DROP TABLE IF EXISTS produktillkategori;
DROP TABLE IF EXISTS bestallda_produkter;
DROP TABLE IF EXISTS faktura;
DROP TABLE IF EXISTS lager;
DROP TABLE IF EXISTS produktHylla;
DROP TABLE IF EXISTS orderrad;
DROP TABLE IF EXISTS produkt;
DROP TABLE IF EXISTS logglista;
DROP TABLE IF EXISTS plocklista;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS kund;
DROP TABLE IF EXISTS varukorg;
 
--
-- ( Table kund )
--
CREATE TABLE kund
(
`kundID`  INT AUTO_INCREMENT NOT NULL,
`fornamn` VARCHAR (20),
`efternamn` VARCHAR (20),
`email` VARCHAR(40),
`fakturadress` VARCHAR (100),
`telefon` VARCHAR(12),
 
PRIMARY KEY (kundID)
);
 
--
-- ( Table Order )
--
CREATE TABLE orders
(
`orderID` INT AUTO_INCREMENT NOT NULL,
`kundID` INT NOT NULL,
`k_namn` VARCHAR (40),
`datum` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`order_status` VARCHAR(10) DEFAULT "Skapad",
`antal_produkter` INT DEFAULT 0,
 
PRIMARY KEY (orderID)
);
 
--
-- ( Table Plocklista )
--
CREATE TABLE plocklista
(
`plockID` INT AUTO_INCREMENT NOT NULL,
`orderID` INT NOT NULL,
`datum` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 
PRIMARY KEY (plockID)
);
 



CREATE TABLE logglista
(
`loggID` INT AUTO_INCREMENT NOT NULL,
`handelse` VARCHAR(80),
`tidshandelse` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

 
PRIMARY KEY (loggID)
);
 
--
-- ( Table Produkt )
--
 
CREATE TABLE produkt
(
`produktID` INT AUTO_INCREMENT NOT NULL,
`namn` CHAR(100) UNIQUE,
`beskrivning` VARCHAR(250),
`bild_url` VARCHAR(300),
`pris` INT,
 
PRIMARY KEY (`produktID`)
);
 
--
-- ( Table OrderRad )
--
CREATE TABLE orderrad
(
`orderID` INT AUTO_INCREMENT NOT NULL,
`produktID` INT NOT NULL,
`antal` INT NOT NULL,
 
PRIMARY KEY (`orderID`)
);
 
 
--
-- ( Table Lagerregister )
--
 
-- CREATE TABLE Lagerregister
-- (
-- `platsID` INT AUTO_INCREMENT NOT NULL,
-- `produktID` INT NOT NULL,
-- `antal` INT NOT NULL,
 
-- PRIMARY KEY(platsID),
-- FOREIGN KEY(produktID) REFERENCES produkt(pr §
-- );
 

DROP TABLE IF EXISTS lager;
CREATE TABLE lager (
  `lagerID` INT AUTO_INCREMENT NOT NULL,
  `namn` CHAR(100),
  `antal` INT,
  `hylla` VARCHAR(60), 

  PRIMARY KEY(`lagerID`)
);


-- CREATE TABLE produktHylla
-- (
--    `id` INT AUTO_INCREMENT NOT NULL,
--    `hylla` VARCHAR(60) REFERENCES lager(`hylla`),
--    `antal` INT REFERENCES Produkt(`antal`)
-- );

--
-- ( Table Faktura )
--
 
CREATE TABLE faktura
(
`fakturaID` INT AUTO_INCREMENT NOT NULL,
`kundID` INT NOT NULL,
`orderID` INT NOT NULL,
`summa` FLOAT NOT NULL,
 
PRIMARY KEY (fakturaID),
FOREIGN KEY (kundID) REFERENCES kund(kundID),
FOREIGN KEY (orderID) REFERENCES Orders(orderID)
);
 
--
-- ( Table Bestallda_produkter )
--
 
CREATE TABLE bestallda_produkter
(
`produktID` INT NOT NULL,
`fakturaID` INT NOT NULL,
`pris` FLOAT,
`namn` VARCHAR(100),
 
PRIMARY KEY (produktID,fakturaID),
FOREIGN KEY (fakturaID) REFERENCES Faktura(FakturaID),
FOREIGN KEY (produktID) REFERENCES Produkt(produktID)
);
 

-- ( Table kännssomettkonstrigtnamn - kasper2022 )

 
CREATE TABLE produktillkategori
(
`kategoriID` INT AUTO_INCREMENT NOT NULL,
`k_namn` VARCHAR(200),
 
PRIMARY KEY (`kategoriID`)
);
 
-- ( Table Kategorisering )
--
 
CREATE TABLE kategorisering
(
`namn` VARCHAR(200),

PRIMARY KEY(`namn`)
);


CREATE TABLE varukorg
(
  `orderID` INT,
  `produktID` INT,
  `namn` CHAR(100),
  `antal` INT,
  `pris` INT
);


 --EXPERMIENTETING with plocklista
-- måns kod



--testar majd kod nu kl 15.10






  -- GROUP_CONCAT(lager.lagerID, '(', lager.antal, ')' SEPARATOR ', ') as Hylla,
  -- (SELECT SUM(antal) FROM lager WHERE)


-- ( Table Logglista )

DROP VIEW IF EXISTS v_plocklista;
CREATE VIEW v_plocklista AS 
    SELECT 
    orderID, p.produktID, p.namn, o.antal AS "Beställt antal", 
--     if sats om l.antal är 0, visa slut lager, annars nej.
    l.antal AS "Aktuellt lager antal",
    l.hylla AS "Hylla"
    FROM produkt AS p
    INNER JOIN varukorg AS o
    ON p.produktID = o.produktID
    INNER JOIN lager as l
    ON p.namn = l.namn;

-- majd kod

-- DROP VIEW IF EXISTS v_Plocklista;
-- CREATE VIEW v_Plocklista AS 
-- SELECT 
--   o.orderID AS orderID,
--   orr.orderID AS OrderRad,
--   p.beskrivning AS Beskrivning, 
--   orr.produktID as Produkt,
--   l.antal as Antal,
--   l.hylla as Hylla
-- FROM Orders as o
--     INNER JOIN OrderRad as orr
--       ON o.orderID = orr.orderID
--     INNER JOIN Produkt as p
--       ON orr.produktID = p.produktID
--     INNER JOIN lager as l
--       ON p.produktID = l.lagerID
--    -- INNER JOIN lager as l
--   ;