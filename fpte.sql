--Na pocetku su jednostavnije procedure koje sluze za upis i prikaz podataka iz baze
--kompleksnije strukture su prikazane kroz trigere i evente
DELIMITER $$

CREATE PROCEDURE provera_username(IN usern VARCHAR(45))
BEGIN
SELECT *
FROM users
WHERE users.username=usern;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS upis_korisnika;
DELIMITER //
CREATE PROCEDURE upis_korisnika(IN uname VARCHAR(50), IN pass VARCHAR(400))
BEGIN
    INSERT INTO users(username, password)
        VALUES(uname,pass);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS podaci_profil;
DELIMITER //
CREATE PROCEDURE podaci_profil(IN u_id VARCHAR(50))
BEGIN
    SELECT * FROM profiles WHERE user_id=u_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS podaci_user;
DELIMITER //
CREATE PROCEDURE podaci_user(IN u_id VARCHAR(50))
BEGIN
    SELECT * FROM users WHERE id=u_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS azur_profil;
DELIMITER //
CREATE PROCEDURE azur_profil(IN pname VARCHAR(255),IN pemail VARCHAR(255),IN pphone VARCHAR(255),IN paddress VARCHAR(255),IN pplace VARCHAR(255), IN u_id VARCHAR(50))
BEGIN
    UPDATE profiles
            SET name=pname, email=pemail, phone=pphone, address=paddress, place=pplace
            WHERE user_id=u_id;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS insert_profil;
DELIMITER //
CREATE PROCEDURE insert_profil(IN pname VARCHAR(255),IN pemail VARCHAR(255),IN pphone VARCHAR(255),IN paddress VARCHAR(255),IN pplace VARCHAR(255), IN u_id VARCHAR(50))
BEGIN
    INSERT INTO profiles(user_id, name, email, phone, address, place)
        VALUE (u_id, pname,pemail,pphone,paddress,pplace);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS korisnici;
DELIMITER //
CREATE PROCEDURE korisnici(IN u_id VARCHAR(50))
BEGIN
    SELECT users.id as uid, users.username, profiles.name FROM users 
                LEFT JOIN profiles ON users.id=profiles.user_id 
                WHERE users.id!=u_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS prim_poruke;
DELIMITER //
CREATE PROCEDURE prim_poruke(IN r_id VARCHAR(50))
BEGIN
    SELECT * FROM messages 
    WHERE recip_id=r_id 
    ORDER BY time DESC;
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS posalji_poruku;
DELIMITER //
CREATE PROCEDURE posalji_poruku(IN m_id INT, IN a_id INT, IN tim INT, IN mess VARCHAR(5000) )
BEGIN
    INSERT INTO messages(auth_id,recip_id,time, message)
            VALUE (m_id, a_Id, tim, mess);
END //
DELIMITER ;



DROP PROCEDURE IF EXISTS izbrisi_poruku;
DELIMITER //
CREATE PROCEDURE izbrisi_poruku(IN m_id VARCHAR(50))
BEGIN
    DELETE FROM messages 
    WHERE id=m_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS role_per;
DELIMITER //
CREATE PROCEDURE role_per(IN r_id VARCHAR(50))
BEGIN
    SELECT t2.perm_desc FROM role_permissions AS t1 LEFT JOIN permissions AS t2
            ON t1.perm_id=t2.id
            WHERE t1.role_id=r_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS dodaj_artikal;
DELIMITER //
CREATE PROCEDURE dodaj_artikal(IN pname VARCHAR(100), IN pdesc VARCHAR(300), IN ptype INT)
BEGIN
	INSERT INTO products(name, pdesc, type_id) 
                     VALUE(pname, pdesc, ptype);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS brisi_artikal;
DELIMITER //
CREATE PROCEDURE brisi_artikal( IN p_id INT)
BEGIN
	DELETE FROM products 
	WHERE products.id = p_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS podaci_artikal;
DELIMITER //
CREATE PROCEDURE podaci_artikal(IN pname VARCHAR(100))
BEGIN
	SELECT * FROM products 
	WHERE products.name = pname;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS brisi_korpu;
DELIMITER //
CREATE PROCEDURE brisi_korpu(IN u_id VARCHAR(50))
BEGIN
    DELETE FROM cart 
	WHERE cart.buyer_id = u_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS podaci_korpa;
DELIMITER //
CREATE PROCEDURE podaci_korpa(IN u_id VARCHAR(50))
BEGIN
    SELECT * 
	FROM cart 
	WHERE cart.buyer_id = u_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS upis_orders;
DELIMITER //
CREATE PROCEDURE upis_orders(IN b_id INT, IN p_id INT, IN pamount INT, IN price INT, IN ptime INT) 
BEGIN
    INSERT INTO orders(buyer_id, product_id, amount, sum_price ,vreme)
        VALUES (b_id, p_id, pamount, price , ptime);
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS podaci_orders;
DELIMITER //
CREATE PROCEDURE podaci_orders(IN b_id INT) 
BEGIN
    SELECT * FROM orders
    INNER JOIN products on orders.product_id=products.id 
    WHERE buyer_id = b_id
    ORDER BY vreme ASC;
END //
DELIMITER ;

INSERT INTO purchases(product_id, time ,amount ,price_piece)
                        VALUES($productId,NOW(),$quantity, $pprice)

DROP PROCEDURE IF EXISTS upis_nabavka;
DELIMITER //
CREATE PROCEDURE upis_nabavka(IN p_id INT, IN ptime DATETIME, IN pamount INT, IN price INT) 
BEGIN
    INSERT INTO purchases(product_id, time ,amount ,price_piece)
                VALUES(p_id, ptime, pamount, price);
END //
DELIMITER ;

--funkcija koliko je korisnik ukupno potrosio novca
DROP FUNCTION IF EXISTS potrosio;
DELIMITER //
CREATE FUNCTION potrosio(u_id INT) RETURNS INT
BEGIN
	DECLARE sum_cena INT;
	SELECT sum(sum_price)
	FROM orders
	INNER JOIN profiles on profiles.user_id=orders.buyer_id
	WHERE buyer_id=u_id
	INTO sum_cena;

	RETURN sum_cena;
END //

DELIMMITER ;



--Triger koji smesta izbrisane poruke u posebnu tabelu
DROP TRIGGER IF EXISTS f;

DELIMITER //
CREATE TRIGGER f
BEFORE DELETE ON messages  
FOR EACH ROW
BEGIN
	INSERT INTO dmessages(auth_id, recip_id, time, message, deleteTime)
		VALUES(OLD.auth_id, OLD.recip_id, OLD.time, OLD.message, NOW());
END //

-- event koji svaki dan brise u potpunosti izbrisane poruke stare nedelju dana
DROP EVENT IF EXISTS j;
DELIMITER //
CREATE EVENT j 
ON SCHEDULE 
EVERY 1 DAY
DO 
BEGIN
	DELETE FROM dmessages WHERE deleteTime < DATE_SUB(NOW(), INTERVAL 1 WEEK);
END //
DELIMITER ;

--triger koji posle izvrsene narudzbine azurira broj na stanju i broj prodatih artikala upisuje izmene i salje poruku adminu
DELIMITER //
DROP TRIGGER IF EXISTS b //

CREATE TRIGGER b
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
DECLARE _amount INT;
DECLARE _stock INT;
DECLARE _price INT;
DECLARE _sold INT;
DECLARE _sum INT;
DECLARE _time INT;
DECLARE _trgovina VARCHAR(300);
DECLARE _name VARCHAR(50);
DECLARE _address VARCHAR(50);

SET _amount=NEW.amount;

SELECT stock, sold, price
FROM products
WHERE products.id=NEW.product_id
INTO _stock, _sold, _price;

SELECT name, address
FROM profiles
WHERE profiles.id=NEW.buyer_id
INTO _name, _address;


UPDATE products SET stock=_stock-_amount WHERE products.id=NEW.product_id;
UPDATE products SET sold=_sold+_amount WHERE products.id=NEW.product_id;

SET _sum=_amount*_price;	
SET _time=UNIX_TIMESTAMP(NOW());

SET _trgovina = CONCAT("Prodato je "
	, _amount, " artikla br ", NEW.product_id," u iznosu od ", _sum, " dinara.");
	INSERT INTO changes(time, product_id, trgovina) VALUES(NOW(), NEW.product_id, _trgovina);
	INSERT INTO messages(auth_id, recip_id ,time ,message) VALUES(1, 1, _time, _trgovina);
END //
DELIMITER ;


--triger koji posle izvrsene narudzbine daje popust korisniku sledecu kupovinu
DELIMITER //
DROP TRIGGER IF EXISTS d //

CREATE TRIGGER d
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
DECLARE  _price, _time INT;
DECLARE _discount INT DEFAULT 0;
DECLARE _message VARCHAR(400);


SELECT sum(sum_price)
FROM cart
WHERE buyer_id=NEW.buyer_id
INTO _price;

IF _price>1000 AND _price<5000 THEN
    SET _discount=5;
END IF;

IF _price>5000 THEN
    SET _discount=10;
END IF;

UPDATE profiles
            SET discount=_discount
            WHERE user_id=NEW.buyer_id;

SET _time=UNIX_TIMESTAMP(NOW());

SET _message = CONCAT(" Ostvarili popust od ", _discount, " %. na sledecu kupovinu.");
	INSERT INTO messages(auth_id, recip_id ,time ,message) VALUES(1,NEW.buyer_id, _time, _message);
	

END //
DELIMITER ;

--posle dopune stanja azurira vrednosti i salje poruku
DELIMITER //
DROP TRIGGER IF EXISTS c //

CREATE TRIGGER c
AFTER INSERT ON purchases
FOR EACH ROW
BEGIN

DECLARE _nameP VARCHAR(50);
DECLARE _stock INT;
DECLARE _time INT;
DECLARE _trgovina VARCHAR(300);

SELECT name, stock
FROM products
INNER JOIN purchases ON purchases.product_id=products.id
WHERE products.id=NEW.product_id AND purchases.time=(SELECT MAX(time) FROM purchases)
INTO _nameP, _stock;


UPDATE products SET stock=_stock+NEW.amount WHERE products.id=NEW.product_id;
UPDATE products SET price=NEW.price_piece/70*100 WHERE products.id=NEW.product_id;
SET _time=UNIX_TIMESTAMP(NOW());

SET _trgovina = CONCAT("Artikal ", _nameP, " je dopunjen sa "
	, new.amount, " po ceni od ", NEW.price_piece," dinara po komadu.");
	INSERT INTO changes(time, product_id, trgovina) VALUES(NOW(), NEW.product_id, _trgovina);
	INSERT INTO messages(auth_id, recip_id ,time ,message) VALUES(1, 1, _time, _trgovina);
END //
DELIMITER ;


--event koji vodi racuna o prodaji na nedeljnom nivou
DROP EVENT IF EXISTS week;
DELIMITER //
CREATE EVENT week
ON SCHEDULE  
EVERY 1 WEEK
DO 
BEGIN
	DELETE FROM weekly;
	INSERT INTO weekly(product_id, sold)
	SELECT
	product_id, SUM(amount) as sum_am
	FROM
	orders
	WHERE vreme>UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 7 DAY))
	GROUP BY product_id
	ORDER BY sum_am DESC;
END //
DELIMITER ;


--event koji salje korisnicima ponudu u inbox
DROP EVENT IF EXISTS sendInbox;
DELIMITER //
CREATE EVENT sendInbox
ON SCHEDULE  
EVERY 1 WEEK
ENDS NOW() + INTERVAL 1 MONTH
DO 
BEGIN
	DECLARE _name VARCHAR(50);
	DECLARE _buyer VARCHAR(50);
	DECLARE _mess VARCHAR(400);
    DECLARE _time INT;
	DECLARE napusti_petlju INT DEFAULT 0;
	DECLARE c CURSOR FOR
	SELECT id
	FROM users;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET napusti_petlju = 1;
    
	SELECT name
	FROM products
	INNER JOIN weekly ON weekly.product_id=products.id
	WHERE weekly.sold=(SELECT MAX(sold) FROM weekly)
	INTO _name;
    
    SET _time=UNIX_TIMESTAMP(NOW());
	OPEN c;
	petlja: LOOP
		FETCH c INTO _buyer;

		IF napusti_petlju = 1 THEN
			SET napusti_petlju = 0;
			LEAVE petlja;
		END IF;
		SET _mess = CONCAT("Samo do kraja nedelje!! Narucite nas najpopularniji proizvod ",_name,
		" i mnoge druge proizvode i ostvarite popust ");
	IF _buyer!=1 THEN
		INSERT INTO messages(auth_id, recip_id ,time ,message) VALUES(1, _buyer,_time,_mess);
	END IF;
	END LOOP;
	CLOSE c;
END //
DELIMITER ;



--event koji smanjuje cenu artiklima koji nisu prodavani u toku nedelje
DROP EVENT IF EXISTS trade;
DELIMITER //
CREATE EVENT trade
ON SCHEDULE
EVERY 1 WEEK
DO
BEGIN
	DECLARE _id , _cena, _c INT;
    DECLARE _trgovina VARCHAR(400);
    DECLARE napusti_petlju INT DEFAULT 0;
	DECLARE c CURSOR FOR
	SELECT products.id, price
	FROM products
	LEFT OUTER JOIN weekly ON weekly.product_id=products.id
    WHERE weekly.product_id IS NULL;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET napusti_petlju = 1;
	
	OPEN c;
	petlja: LOOP
		FETCH c INTO _id, _cena;

		IF napusti_petlju = 1 THEN
			SET napusti_petlju = 0;
			LEAVE petlja;
		END IF;
		SET _c=_cena/100*95;
		UPDATE products SET price=_c WHERE products.id=_id;
		
		SET _trgovina = CONCAT("Artikal ", _id, " je snizen na"
		, _c," dinara po komadu.");
	INSERT INTO changes(time, product_id, trgovina) VALUES(NOW(), _id , _trgovina);

	END LOOP;
	CLOSE c;
END //
DELIMITER ;


--event koji svake nedelje dopunjuje stanje cesto prodavanih artikala
DROP EVENT IF EXISTS addItems;
DELIMITER //
CREATE EVENT addItems
ON SCHEDULE
EVERY 1 WEEK
DO
BEGIN
	DECLARE _id INT;
	DECLARE _stanje INT;
	DECLARE _br_prod INT;
	DECLARE _cena INT;
	DECLARE napusti_petlju INT DEFAULT 0;
	DECLARE c CURSOR FOR
	
    SELECT products.id, stock, weekly.sold, price
	FROM products
	INNER JOIN weekly ON weekly.product_id=products.id
	GROUP BY products.id
    ORDER BY products.id;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET napusti_petlju = 1;
	
	OPEN c;
	
	petlja: LOOP
		FETCH c INTO _id, _stanje, _br_prod, _cena;

		IF napusti_petlju = 1 THEN
			SET napusti_petlju = 0;
			LEAVE petlja;
		END IF;

		IF _br_prod>_stanje THEN
		INSERT INTO purchases(product_id ,time, amount,price_piece) VALUES (_id, NOW(),_br_prod*2, _cena/100*70);
		END IF;

	END LOOP;
	CLOSE c;
END //
DELIMITER ;

