-- Start ESHOP
 USE eshop;

--                  Get all Customers
-- /////////////////////////////////////////////////////

DROP PROCEDURE IF EXISTS get_customer;
DELIMITER ;;
CREATE PROCEDURE get_customer()
BEGIN
    SELECT * from kund;
END;;
DELIMITER ;

--                  Get specific Customers
-- /////////////////////////////////////////////////////

DROP PROCEDURE IF EXISTS get_one_customer;
DELIMITER ;;
CREATE PROCEDURE get_one_customer(
    o_id INT
)
BEGIN
    SELECT * FROM kund WHERE kundID = o_id;
END;;
DELIMITER ;

--         Get specific category from a input
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS get_category;
DELIMITER ;;
CREATE PROCEDURE get_category(
    p_kategoriID INT
)
BEGIN
    SELECT * FROM produktillkategori WHERE kategoriID = p_kategoriID;
END
;;
DELIMITER ;

--                 Get all categories
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS get_categories;
DELIMITER ;;
CREATE PROCEDURE get_categories()
BEGIN
    SELECT * FROM kategorisering;
END;;
DELIMITER ;

--          Create category for specific prodcut
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS create_product_category;
DELIMITER ;;
CREATE PROCEDURE create_product_category(
    `insert_namn` VARCHAR(200)
    )
BEGIN
        INSERT INTO produktillkategori(k_namn)
        VALUES(insert_namn);
END
;;
DELIMITER ;

--                 Get Product categories
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS get_product_categories;
DELIMITER ;;
CREATE PROCEDURE get_product_categories()
BEGIN
-- namn == kategorinamn (går efter ddl.sql)
-- kg för kategorisering (förkortning)

    SELECT p_kategoriID, namn FROM produktillkategori as p
        JOIN kategorisering as kg
            ON p_kategoriID = kg.kategoriID
    WHERE kg.produktID = @p_produktID;
END;;
DELIMITER ;

--                 Create a product
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS create_product;
DELIMITER ;;
CREATE PROCEDURE create_product(

    `p_namn` CHAR(100),
    `p_beskrivning` VARCHAR(250),
    `p_bild_url` VARCHAR(300),
    `p_pris` INT
    )
BEGIN
        INSERT INTO produkt(namn,beskrivning,bild_url,pris)
        VALUES(p_namn,p_beskrivning,p_bild_url,p_pris);

END
;;
DELIMITER ;

--                Get all the shelves
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS get_shelves;
DELIMITER ;;
CREATE PROCEDURE get_shelves()
BEGIN
    SELECT hylla FROM lager;
END;;
DELIMITER ;

--               Get all the products
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS get_all_products;
DELIMITER ;;
CREATE PROCEDURE get_all_products()
BEGIN
    SELECT p.produktID, p.namn,p.beskrivning, p.bild_url, p.pris,l.antal, k.k_namn FROM produkt AS p
    JOIN lager AS l
        ON p.produktID = l.lagerID
    JOIN produktillkategori AS k
        ON p.produktID = k.kategoriID
    ;
END;;
DELIMITER ;

--               Get a specific product
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS get_one_product;
DELIMITER ;;
CREATE PROCEDURE get_one_product(
    p_produktID INT
)
BEGIN
    SELECT * FROM produkt WHERE produktID = p_produktID;
END;;
DELIMITER ;

--            Delete a specific product
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS delete_product;
DELIMITER ;;
CREATE PROCEDURE delete_product(
    p_produktID INT
)
BEGIN
    DELETE FROM produktillkategori WHERE kategoriID = p_produktID;
    DELETE FROM produkt WHERE produktID = p_produktID;
    DELETE FROM lager WHERE lagerID = p_produktID;
END ;;
DELIMITER ;

--            Edit a specific product
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS edit_product;
DELIMITER ;;
CREATE PROCEDURE edit_product(
    `p_produktID` INT,
    `p_namn` CHAR(100),
    `p_beskrivning` VARCHAR(250),
    `p_bild_url` VARCHAR(300),
    `p_pris` INT
    )
BEGIN    
    UPDATE produkt
        SET produktID = p_produktID,
            namn = p_namn,
            pris = p_pris,
            beskrivning = p_beskrivning,
            bild_url = p_bild_url
        WHERE produktID = p_produktID
    ;
END ;;
DELIMITER ;

--                      Get varukorg
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS get_varukorg;
DELIMITER ;;
CREATE PROCEDURE get_varukorg(
    `v_orderID` INT
)
BEGIN
    SELECT * FROM varukorg WHERE orderID = v_orderID
    ;
END;;
DELIMITER ;

--                      create varukorg
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS create_varukorg;
DELIMITER ;;
CREATE PROCEDURE create_varukorg(

    `v_orderID` INT,
    `v_produktID` INT,
    `v_namn` CHAR(100),
    `v_antal` INT,
    `v_pris` INT
    )
BEGIN
        INSERT INTO varukorg(orderID,produktID,namn,antal,pris)
        VALUES(v_orderID,v_produktID,v_namn,v_antal,v_pris);

END
;;
DELIMITER ;

--                 Create a lager column
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS create_lager_column;
DELIMITER ;;
CREATE PROCEDURE create_lager_column(

    `l_LagerID` INT,
    `l_namn` CHAR(50),
    `l_antal` INT,
    `l_hylla` VARCHAR(60)
    )
BEGIN
        INSERT INTO lager(LagerID,namn,antal,hylla)
        VALUES(l_LagerID,l_namn,l_antal,l_hylla);
END
;;
DELIMITER ;

--                 Update lager column
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS update_lager_column;
DELIMITER ;;
CREATE PROCEDURE update_lager_column(

    `l_lagerID` INT,
    `l_antal` INT
    )
BEGIN
    UPDATE lager
        SET antal = antal - l_antal
        WHERE lagerID = l_lagerID
    ;
END
;;
DELIMITER ;

--                Get whole inventoryx
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS inventory_all;
DELIMITER ;;
CREATE PROCEDURE inventory_all()
BEGIN
    SELECT p.produktID, p.namn, l.hylla, l.antal FROM produkt AS p
        JOIN lager AS l
            ON p.produktID = l.lagerID
        ;
END ;;
DELIMITER ;

--                Get specific inventory
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS inventory;
DELIMITER ;;
CREATE PROCEDURE inventory
(
    IN search VARCHAR(100)
    )
BEGIN
    SELECT p.produktID, p.namn, l.hylla , l.antal/*AS hylla*/ FROM produkt AS p
        JOIN lager AS l
            ON p.produktID = l.lagerID
    WHERE p.produktID LIKE search
        OR p.namn LIKE search
        OR l.hylla LIKE search
        OR l.antal LIKE search
        ;
END ;;
DELIMITER ;

--                  Add antal to inventory
-- /////////////////////////////////////////////////////
-- <productid> <shelf> <number> 

DROP PROCEDURE IF EXISTS add_2_inventory;
DELIMITER ;;
CREATE PROCEDURE add_2_inventory(
        IN p_lagerID INT,
        IN p_hylla VARCHAR(200),
        IN p_antal INT,
        IN p_namn CHAR(50)
    )
BEGIN
        INSERT INTO lager(lagerID, hylla, antal, namn)
                VALUES(p_lagerID, p_hylla, p_antal, p_namn)
        ON DUPLICATE KEY UPDATE antal = antal + p_antal;
        INSERT INTO produkt(produktID, namn , beskrivning, bild_url, pris)
                VALUES (p_lagerID, p_namn, "Custom product" , "images/auto.jpeg", 1337 );
END ;;
DELIMITER ;

--           Remove specific from inventory
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS remove_from_inv;
DELIMITER ;;
CREATE PROCEDURE remove_from_inv(
        IN p_lagerID INT,
        IN p_hylla VARCHAR(200),
        IN p_antal INT
)
BEGIN
IF p_antal IS NOT NULL THEN
UPDATE lager
   SET antal = antal - p_antal
           WHERE lagerID = p_lagerID  AND hylla = p_hylla;
   END IF;


END ;;
DELIMITER ;

--                     Get Logs
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS logs;
DELIMITER ;;
CREATE PROCEDURE logs(number INT)
BEGIN
    SELECT loggID, tidshandelse, handelse FROM logglista
    ORDER BY loggID DESC
    LIMIT number;
END
;;
DELIMITER ;

--           Log when adding a product
-- /////////////////////////////////////////////////////
DROP TRIGGER IF EXISTS log_produkt_add;
DELIMITER ;;
CREATE TRIGGER log_produkt_add
AFTER INSERT
ON produkt
FOR EACH ROW
BEGIN
    SET @handelse = CONCAT("Ny produkt las till med följande ProduktID`", new.produktID,"`!");
    INSERT INTO logglista(`handelse`)
        VALUES (@handelse);
END ;; 
DELIMITER ;

--           Log when updating a product
-- /////////////////////////////////////////////////////
DROP TRIGGER IF EXISTS log_produkt_update;
DELIMITER ;;
CREATE TRIGGER log_produkt_update
AFTER UPDATE
ON produkt
FOR EACH ROW
BEGIN
    SET @handelse = CONCAT("Detaljer för följande ProduktID`", new.produktID," `har uppdaterats!");
    INSERT INTO logglista(`handelse`)
        VALUES (@handelse);
END ;; 
DELIMITER ;

--           Log when removing a product
-- /////////////////////////////////////////////////////
DROP TRIGGER IF EXISTS log_produkt_delete;
DELIMITER ;;
CREATE TRIGGER log_produkt_delete
AFTER DELETE
ON produkt
FOR EACH ROW
BEGIN
    SET @handelse = CONCAT("Produkt togs bort med följande ProduktID`", old.produktID," `!");
    INSERT INTO logglista(`handelse`)
        VALUES (@handelse);
END ;; 
DELIMITER ;

--                  Show all orders
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS show_orders;
DELIMITER ;;
CREATE PROCEDURE show_orders()
BEGIN
    SELECT * FROM orders;
END ;;
DELIMITER ;

--                  Show orders with search
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS search_order;   
DELIMITER ;;
CREATE PROCEDURE search_order(
    IN search VARCHAR(100)
)
BEGIN
SELECT o.orderID, kundID, datum, o.antal_produkter AS `Antal Produkter`, o.order_status FROM orders as o
    WHERE o.orderID LIKE search
        OR kundID LIKE search
        GROUP BY o.orderID
        ;
 END ;;
DELIMITER ;


--                  Create order
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS create_order;
DELIMITER ;;
CREATE PROCEDURE create_order (
    id INT,
    namn VARCHAR(40)
    )
BEGIN
    INSERT INTO orders(`kundID`, `k_namn`)
    VALUES (id, namn)
    ;
END ;;
DELIMITER ;


--                  Add orderRad in tabell
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS create_order_row;
DELIMITER ;;
CREATE PROCEDURE create_order_row(
    p_orderID INT,
    p_produktID INT,
    p_antal INT
    )
BEGIN
    INSERT INTO orderrad(`orderID`, `produktID`, `antal`)
    VALUES (p_orderID, p_produktID, p_antal);
END ;;
DELIMITER ;

--                  Show orderStatus
-- /////////////////////////////////////////////////////
DROP FUNCTION IF EXISTS order_status;
DELIMITER ;;
-- CREATE PROCEDURE orderStatus ()

CREATE FUNCTION order_status (
    f_skapad TIMESTAMP,
    f_borttagen TIMESTAMP,
    f_skickad TIMESTAMP,
    f_tillagd TIMESTAMP,
    f_uppdaterat TIMESTAMP
)

RETURNS CHAR (20)
DETERMINISTIC 
BEGIN
 IF f_skickad IS NOT NULL THEN

        RETURN "skickad!";

    ELSEIF f_borttagen IS NOT NULL THEN

        RETURN "raderad!";

    ELSEIF f_tillagd IS NOT NULL THEN

        RETURN "beställd!";

    ELSEIF f_uppdaterat IS NOT NULL THEN

        RETURN "uppdaterad!";

    ELSEIF f_skapad IS NOT NULL THEN

        RETURN "skapad!";

    END IF;

END ;;
DELIMITER ;

--                      Update order
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS update_order;
DELIMITER ;;
CREATE PROCEDURE update_order(
    `o_orderID` INT,
    `o_antal` INT
    )
BEGIN    
    UPDATE orders
        SET antal_produkter = antal_produkter + o_antal
        WHERE orderID = o_orderID
    ;
END ;;
DELIMITER ;

--                      Plocklista
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS pick_List;
DELIMITER ;;
CREATE PROCEDURE pick_List (
     id INT
)
BEGIN
    SELECT * FROM v_plocklista
    WHERE
        `orderID` = id
        ;
END ;;
DELIMITER ;

--            Update order status to Skickad
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS ship;
DELIMITER ;;
CREATE PROCEDURE ship(
    `o_orderID` INT
    )
BEGIN    
    UPDATE orders
        SET order_status = "Skickad"
        WHERE orderID = o_orderID
    ;
END ;;
DELIMITER ;

--            Update order status to Beställd
-- /////////////////////////////////////////////////////
DROP PROCEDURE IF EXISTS ordered;
DELIMITER ;;
CREATE PROCEDURE ordered(
    `o_orderID` INT
    )
BEGIN
    UPDATE orders
        SET order_status = "Beställd"
        WHERE orderID = o_orderID
    ;
END ;;
DELIMITER ;
