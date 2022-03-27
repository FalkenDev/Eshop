
CREATE DATABASE IF NOT EXISTS eshop;
USE eshop;

CREATE USER IF NOT EXISTS 'dbadm'@'localhost'
    IDENTIFIED BY 'P@ssw0rd';



GRANT ALL PRIVILEGES
    ON eshop.*
    TO 'dbadm'@'localhost';

FLUSH PRIVILEGES;

