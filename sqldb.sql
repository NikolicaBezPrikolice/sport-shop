-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 05, 2022 at 03:42 PM
-- Server version: 5.7.36
-- PHP Version: 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sqldb`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `azur_profil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `azur_profil` (IN `pname` VARCHAR(255), IN `pemail` VARCHAR(255), IN `pphone` VARCHAR(255), IN `paddress` VARCHAR(255), IN `pplace` VARCHAR(255), IN `u_id` VARCHAR(50))  BEGIN
    UPDATE profiles
            SET name=pname, email=pemail, phone=pphone, address=paddress, place=pplace
            WHERE user_id=u_id;
END$$

DROP PROCEDURE IF EXISTS `brisi_artikal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `brisi_artikal` (IN `p_id` INT)  BEGIN
	DELETE FROM products 
	WHERE products.id = p_id;
END$$

DROP PROCEDURE IF EXISTS `brisi_korpu`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `brisi_korpu` (IN `u_id` VARCHAR(50))  BEGIN
    DELETE FROM cart 
	WHERE cart.buyer_id = u_id;
END$$

DROP PROCEDURE IF EXISTS `dodaj_artikal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `dodaj_artikal` (IN `pname` VARCHAR(100), IN `pdesc` VARCHAR(300), IN `ptype` INT)  BEGIN
	INSERT INTO products(name, pdesc, type_id) 
                     VALUE(pname, pdesc, ptype);
END$$

DROP PROCEDURE IF EXISTS `insert_profil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_profil` (IN `pname` VARCHAR(255), IN `pemail` VARCHAR(255), IN `pphone` VARCHAR(255), IN `paddress` VARCHAR(255), IN `pplace` VARCHAR(255), IN `u_id` VARCHAR(50))  BEGIN
    INSERT INTO profiles(user_id, name, email, phone, address, place)
        VALUE (u_id, pname,pemail,pphone,paddress,pplace);
END$$

DROP PROCEDURE IF EXISTS `izbrisi_poruku`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `izbrisi_poruku` (IN `m_id` VARCHAR(50))  BEGIN
    DELETE FROM messages 
    WHERE id=m_id;
END$$

DROP PROCEDURE IF EXISTS `korisnici`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `korisnici` (IN `u_id` VARCHAR(50))  BEGIN
    SELECT users.id as uid, users.username, profiles.name FROM users 
                LEFT JOIN profiles ON users.id=profiles.user_id 
                WHERE users.id!=u_id;
END$$

DROP PROCEDURE IF EXISTS `panel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `panel` ()  BEGIN
	SELECT products.name, sum(orders.amount), sum(orders.sum_price)
	FROM products
	INNER JOIN orders on products.id=orders.product_id
	GROUP BY products.name;

	SELECT products.name, sum(purchases.amount), sum(purchases.price_piece)
	FROM products
	INNER JOIN purchases on products.id=purchases.product_id
	GROUP BY products.name;
END$$

DROP PROCEDURE IF EXISTS `podaci_artikal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `podaci_artikal` (IN `pname` VARCHAR(100))  BEGIN
	SELECT * FROM products 
	WHERE products.name = pname;
END$$

DROP PROCEDURE IF EXISTS `podaci_korpa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `podaci_korpa` (IN `u_id` VARCHAR(50))  BEGIN
    SELECT * 
	FROM cart 
	WHERE cart.buyer_id = u_id;
END$$

DROP PROCEDURE IF EXISTS `podaci_orders`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `podaci_orders` (IN `b_id` INT)  BEGIN
    SELECT * FROM orders
    INNER JOIN products on orders.product_id=products.id 
    WHERE buyer_id = b_id
    ORDER BY vreme ASC;
END$$

DROP PROCEDURE IF EXISTS `podaci_profil`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `podaci_profil` (IN `u_id` VARCHAR(50))  BEGIN
    SELECT * FROM profiles WHERE user_id=u_id;
END$$

DROP PROCEDURE IF EXISTS `podaci_user`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `podaci_user` (IN `u_id` VARCHAR(50))  BEGIN
    SELECT * FROM users WHERE id=u_id;
END$$

DROP PROCEDURE IF EXISTS `posalji_poruku`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `posalji_poruku` (IN `m_id` INT, IN `a_id` INT, IN `tim` INT, IN `mess` VARCHAR(5000))  BEGIN
    INSERT INTO messages(auth_id,recip_id,time, message)
            VALUE (m_id, a_Id, tim, mess);
END$$

DROP PROCEDURE IF EXISTS `prim_poruke`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `prim_poruke` (IN `r_id` VARCHAR(50))  BEGIN
    SELECT * FROM messages 
    WHERE recip_id=r_id 
    ORDER BY time DESC;
END$$

DROP PROCEDURE IF EXISTS `provera_username`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `provera_username` (IN `usern` VARCHAR(45))  BEGIN
SELECT *
FROM users
WHERE users.username=usern;

END$$

DROP PROCEDURE IF EXISTS `role_per`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `role_per` (IN `r_id` VARCHAR(50))  BEGIN
    SELECT t2.perm_desc FROM role_permissions AS t1 LEFT JOIN permissions AS t2
            ON t1.perm_id=t2.id
            WHERE t1.role_id=r_id;
END$$

DROP PROCEDURE IF EXISTS `upis_korisnika`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `upis_korisnika` (IN `uname` VARCHAR(50), IN `pass` VARCHAR(400))  BEGIN
    INSERT INTO users(username, password)
        VALUES(uname,pass);
END$$

DROP PROCEDURE IF EXISTS `upis_nabavka`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `upis_nabavka` (IN `p_id` INT, IN `ptime` DATETIME, IN `pamount` INT, IN `price` INT)  BEGIN
    INSERT INTO purchases(product_id, time ,amount ,price_piece)
                VALUES(p_id, ptime, pamount, price);
END$$

DROP PROCEDURE IF EXISTS `upis_orders`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `upis_orders` (IN `b_id` INT, IN `p_id` INT, IN `pamount` INT, IN `price` INT, IN `ptime` INT)  BEGIN
    INSERT INTO orders(buyer_id, product_id, amount, sum_price ,vreme)
        VALUES (b_id, p_id, pamount, price , ptime);
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `potrosio`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `potrosio` (`u_id` INT) RETURNS INT(11) BEGIN
	DECLARE sum_cena INT;
	SELECT sum(sum_price)
	FROM orders
	INNER JOIN profiles on profiles.user_id=orders.buyer_id
	WHERE buyer_id=u_id
	INTO sum_cena;

	RETURN sum_cena;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
CREATE TABLE IF NOT EXISTS `cart` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `buyer_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `sum_price` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

-- --------------------------------------------------------

--
-- Table structure for table `changes`
--

DROP TABLE IF EXISTS `changes`;
CREATE TABLE IF NOT EXISTS `changes` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `trgovina` varchar(300) COLLATE utf16_slovenian_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `changes`
--

INSERT INTO `changes` (`id`, `time`, `product_id`, `trgovina`) VALUES
(1, '2022-09-05 15:12:29', 1, 'Artikal adidas lopta je dopunjen sa 10 po ceni od1500 evra po komadu.'),
(2, '2022-09-05 15:13:01', 2, 'Artikal spalding lopta je dopunjen sa 5 po ceni od1000 evra po komadu.'),
(3, '2022-09-05 15:25:20', 3, 'Artikal nike kopacke je dopunjen sa 20 po ceni od 6000 dinara po komadu.'),
(4, '2022-09-05 15:25:33', 4, 'Artikal srbija dres je dopunjen sa 10 po ceni od 8000 dinara po komadu.'),
(5, '2022-09-05 16:05:24', 4, 'Prodato je 1 artikla br 4 u iznosu od 11429 evra.'),
(6, '2022-09-05 16:06:42', 3, 'Prodato je 1 artikla br 3 u iznosu od 8571 evra.'),
(7, '2022-09-05 16:09:08', 2, 'Prodato je 1 artikla br 2 u iznosu od 1429 evra.'),
(8, '2022-09-05 16:09:08', 1, 'Prodato je 1 artikla br 1 u iznosu od 2143 evra.'),
(9, '2022-09-05 16:30:10', 3, 'Prodato je 1 artikla br 3 u iznosu od 8571 evra.'),
(10, '2022-09-05 16:30:10', 1, 'Prodato je 1 artikla br 1 u iznosu od 2143 evra.'),
(11, '2022-09-05 16:42:56', 2, 'Prodato je 1 artikla br 2 u iznosu od 1429 evra.'),
(12, '2022-09-05 16:56:02', 1, 'Prodato je 1 artikla br 1 u iznosu od 2143 evra.'),
(13, '2022-09-05 17:03:13', 1, 'Artikal 1 je snizen na2036 dinara po komadu.'),
(14, '2022-09-05 17:03:13', 2, 'Artikal 2 je snizen na1358 dinara po komadu.'),
(15, '2022-09-05 17:03:13', 3, 'Artikal 3 je snizen na8142 dinara po komadu.'),
(16, '2022-09-05 17:03:13', 4, 'Artikal 4 je snizen na10858 dinara po komadu.'),
(17, '2022-09-05 17:15:34', 2, 'Prodato je 2 artikla br 2 u iznosu od 2716 evra.'),
(18, '2022-09-05 17:34:46', 2, 'Artikal spalding lopta je dopunjen sa 8 po ceni od 951 dinara po komadu.');

-- --------------------------------------------------------

--
-- Table structure for table `dmessages`
--

DROP TABLE IF EXISTS `dmessages`;
CREATE TABLE IF NOT EXISTS `dmessages` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `auth_id` int(10) UNSIGNED NOT NULL,
  `recip_id` int(10) UNSIGNED NOT NULL,
  `time` int(10) UNSIGNED NOT NULL,
  `message` varchar(4096) COLLATE utf16_slovenian_ci NOT NULL,
  `deleteTime` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `auth_id` (`auth_id`),
  KEY `recip_id` (`recip_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `dmessages`
--

INSERT INTO `dmessages` (`id`, `auth_id`, `recip_id`, `time`, `message`, `deleteTime`) VALUES
(1, 1, 1, 1662383549, 'Artikal adidas lopta je dopunjen sa 10 po ceni od1500 evra po komadu.', '2022-09-05');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `auth_id` int(10) UNSIGNED NOT NULL,
  `recip_id` int(10) UNSIGNED NOT NULL,
  `time` int(10) UNSIGNED NOT NULL,
  `message` varchar(4096) COLLATE utf16_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `auth_id` (`auth_id`),
  KEY `recip_id` (`recip_id`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `auth_id`, `recip_id`, `time`, `message`) VALUES
(3, 1, 1, 1662384320, 'Artikal nike kopacke je dopunjen sa 20 po ceni od 6000 dinara po komadu.'),
(2, 1, 1, 1662383581, 'Artikal spalding lopta je dopunjen sa 5 po ceni od1000 evra po komadu.'),
(4, 1, 1, 1662384333, 'Artikal srbija dres je dopunjen sa 10 po ceni od 8000 dinara po komadu.'),
(5, 1, 1, 1662386724, 'Prodato je 1 artikla br 4 u iznosu od 11429 evra.'),
(6, 1, 2, 1662386724, ' Ostvarili popust od 10 %. na sledecu kupovinu.'),
(7, 1, 1, 1662386802, 'Prodato je 1 artikla br 3 u iznosu od 8571 evra.'),
(8, 1, 2, 1662386802, ' Ostvarili popust od 10 %. na sledecu kupovinu.'),
(9, 1, 1, 1662386948, 'Prodato je 1 artikla br 2 u iznosu od 1429 evra.'),
(10, 1, 2, 1662386948, ' Ostvarili popust od 5 %. na sledecu kupovinu.'),
(11, 1, 1, 1662386948, 'Prodato je 1 artikla br 1 u iznosu od 2143 evra.'),
(12, 1, 2, 1662386948, ' Ostvarili popust od 5 %. na sledecu kupovinu.'),
(13, 1, 1, 1662388210, 'Prodato je 1 artikla br 3 u iznosu od 8571 evra.'),
(14, 1, 2, 1662388210, ' Ostvarili popust od 10 %. na sledecu kupovinu.'),
(15, 1, 1, 1662388210, 'Prodato je 1 artikla br 1 u iznosu od 2143 evra.'),
(16, 1, 2, 1662388210, ' Ostvarili popust od 10 %. na sledecu kupovinu.'),
(17, 1, 1, 1662388976, 'Prodato je 1 artikla br 2 u iznosu od 1429 evra.'),
(18, 1, 2, 1662388976, ' Ostvarili popust od 5 %. na sledecu kupovinu.'),
(19, 1, 1, 1662389762, 'Prodato je 1 artikla br 1 u iznosu od 2143 evra.'),
(20, 1, 2, 1662389762, ' Ostvarili popust od 5 %. na sledecu kupovinu.'),
(21, 1, 2, 1662389789, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(22, 1, 2, 1662389794, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(23, 1, 2, 1662389799, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(24, 1, 2, 1662389804, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(25, 1, 2, 1662389809, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(26, 1, 2, 1662389814, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(27, 1, 2, 1662389819, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(28, 1, 2, 1662389824, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(29, 1, 2, 1662389829, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(30, 1, 2, 1662389834, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(31, 1, 2, 1662389839, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(32, 1, 2, 1662389844, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(33, 1, 2, 1662389849, 'Samo do kraja nedelje!! Narucite nas najpopularniji proizvod adidas lopta i mnoge druge proizvode i ostvarite popust '),
(34, 1, 1, 1662390934, 'Prodato je 2 artikla br 2 u iznosu od 2716 evra.'),
(35, 1, 2, 1662390934, ' Ostvarili popust od 5 %. na sledecu kupovinu.'),
(36, 1, 1, 1662392086, 'Artikal spalding lopta je dopunjen sa 8 po ceni od 951 dinara po komadu.');

--
-- Triggers `messages`
--
DROP TRIGGER IF EXISTS `f`;
DELIMITER $$
CREATE TRIGGER `f` BEFORE DELETE ON `messages` FOR EACH ROW BEGIN
	INSERT INTO dmessages(auth_id, recip_id, time, message, deleteTime)
		VALUES(OLD.auth_id, OLD.recip_id, OLD.time, OLD.message, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `buyer_id` int(10) UNSIGNED NOT NULL,
  `product_id` int(10) UNSIGNED NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `sum_price` int(10) UNSIGNED NOT NULL,
  `vreme` text COLLATE utf16_slovenian_ci,
  PRIMARY KEY (`id`),
  KEY `buyer_id` (`buyer_id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `buyer_id`, `product_id`, `amount`, `sum_price`, `vreme`) VALUES
(1, 2, 4, 1, 11429, '1662386724'),
(2, 2, 3, 1, 8571, '1662386802'),
(3, 2, 2, 1, 1429, '1662386948'),
(4, 2, 1, 1, 2143, '1662386948'),
(5, 2, 3, 1, 8571, '1662388210'),
(6, 2, 1, 1, 2143, '1662388210'),
(7, 2, 2, 1, 1429, '1662388976'),
(8, 2, 1, 1, 2143, '1662389762'),
(9, 2, 2, 2, 2716, '1662390934');

--
-- Triggers `orders`
--
DROP TRIGGER IF EXISTS `b`;
DELIMITER $$
CREATE TRIGGER `b` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
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
	, _amount, " artikla br ", NEW.product_id," u iznosu od ", _sum, " evra.");
	INSERT INTO changes(time, product_id, trgovina) VALUES(NOW(), NEW.product_id, _trgovina);
	INSERT INTO messages(auth_id, recip_id ,time ,message) VALUES(1, 1, _time, _trgovina);
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `d`;
DELIMITER $$
CREATE TRIGGER `d` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
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


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `perm_desc` varchar(200) COLLATE utf16_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `perm_desc`) VALUES
(1, 'Run SQL');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf16_slovenian_ci NOT NULL,
  `stock` int(11) DEFAULT '0',
  `sold` int(11) DEFAULT '0',
  `price` int(11) DEFAULT '0',
  `pdesc` varchar(200) COLLATE utf16_slovenian_ci NOT NULL,
  `type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_id` (`type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `stock`, `sold`, `price`, `pdesc`, `type_id`) VALUES
(1, 'adidas lopta', 7, 3, 2036, 'kozna fudbalska lopta broj 5', 3),
(2, 'spalding lopta', 9, 4, 1359, 'Kosarkaska Nba lopta', 3),
(3, 'nike kopacke', 18, 2, 8142, 'Nike kopacke model bg7d8', 1),
(4, 'srbija dres', 9, 1, 10858, 'kosarkaski dres srbije sa evropskog prvenstva', 2);

-- --------------------------------------------------------

--
-- Table structure for table `prod_types`
--

DROP TABLE IF EXISTS `prod_types`;
CREATE TABLE IF NOT EXISTS `prod_types` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(45) COLLATE utf16_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `prod_types`
--

INSERT INTO `prod_types` (`id`, `name`) VALUES
(1, 'obuca'),
(2, 'odeca'),
(3, 'oprema');

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE IF NOT EXISTS `profiles` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(255) COLLATE utf16_slovenian_ci NOT NULL,
  `email` varchar(255) COLLATE utf16_slovenian_ci NOT NULL,
  `phone` varchar(255) COLLATE utf16_slovenian_ci NOT NULL,
  `address` varchar(255) COLLATE utf16_slovenian_ci NOT NULL,
  `place` varchar(255) COLLATE utf16_slovenian_ci NOT NULL,
  `discount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `user_id`, `name`, `email`, `phone`, `address`, `place`, `discount`) VALUES
(1, 2, 'pera peric', 'pera@mail.com', '0184521856', 'ulica 1', 'nis', 5);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

DROP TABLE IF EXISTS `purchases`;
CREATE TABLE IF NOT EXISTS `purchases` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` int(10) UNSIGNED NOT NULL,
  `time` datetime DEFAULT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `price_piece` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`id`, `product_id`, `time`, `amount`, `price_piece`) VALUES
(1, 1, '2022-09-05 15:12:29', 10, 1500),
(2, 2, '2022-09-05 15:13:01', 5, 1000),
(3, 3, '2022-09-05 15:25:20', 20, 6000),
(4, 4, '2022-09-05 15:25:33', 10, 8000),
(5, 2, '2022-09-05 17:34:46', 8, 951);

--
-- Triggers `purchases`
--
DROP TRIGGER IF EXISTS `c`;
DELIMITER $$
CREATE TRIGGER `c` AFTER INSERT ON `purchases` FOR EACH ROW BEGIN

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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` varchar(200) COLLATE utf16_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_name`) VALUES
(1, 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE IF NOT EXISTS `role_permissions` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` int(10) UNSIGNED NOT NULL,
  `perm_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `perm_id` (`perm_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`id`, `role_id`, `perm_id`) VALUES
(1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(30) COLLATE utf16_slovenian_ci NOT NULL,
  `password` varchar(255) COLLATE utf16_slovenian_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`(6))
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'admin', '$2y$10$y.VWbq8UIHybWgliZEAZWuzSImrcKOXw6F0i2iHKCMz4pKvyXSEle'),
(2, 'korisnik1', '$2y$10$v.5Fi.Vra/mz0wPDJ2jxo.iNDyfnHgoOSeSe74TRCYmFxkaU8Q21e');

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE IF NOT EXISTS `user_roles` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`id`, `user_id`, `role_id`) VALUES
(1, 1, 1),
(2, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `weekly`
--

DROP TABLE IF EXISTS `weekly`;
CREATE TABLE IF NOT EXISTS `weekly` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` int(10) UNSIGNED NOT NULL,
  `sold` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=85 DEFAULT CHARSET=utf16 COLLATE=utf16_slovenian_ci;

--
-- Dumping data for table `weekly`
--

INSERT INTO `weekly` (`id`, `product_id`, `sold`) VALUES
(81, 2, 4),
(82, 1, 3),
(83, 3, 2),
(84, 4, 1);

DELIMITER $$
--
-- Events
--
DROP EVENT IF EXISTS `week`$$
CREATE DEFINER=`root`@`localhost` EVENT `week` ON SCHEDULE EVERY 1 MINUTE STARTS '2022-09-05 16:39:25' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
	DELETE FROM weekly;
	INSERT INTO weekly(product_id, sold)
	SELECT
	product_id, SUM(amount) as sum_am
	FROM
	orders
	WHERE vreme>UNIX_TIMESTAMP(DATE_SUB(NOW(), INTERVAL 7 DAY))
	GROUP BY product_id
	ORDER BY sum_am DESC;
END$$

DROP EVENT IF EXISTS `addItems`$$
CREATE DEFINER=`root`@`localhost` EVENT `addItems` ON SCHEDULE EVERY 1 WEEK STARTS '2022-09-05 17:14:46' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
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
		INSERT INTO purchases(product_id ,time, amount, price_piece) VALUES (_id,NOW(), _br_prod*2, _cena/100*70);
		END IF;

	END LOOP;
	CLOSE c;
END$$

DROP EVENT IF EXISTS `deletemes`$$
CREATE DEFINER=`root`@`localhost` EVENT `deletemes` ON SCHEDULE EVERY 1 DAY STARTS '2022-08-22 19:18:54' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
	DELETE FROM dmessages WHERE deleteTime < DATE_SUB(NOW(), INTERVAL 1 WEEK);
END$$

DROP EVENT IF EXISTS `trade`$$
CREATE DEFINER=`root`@`localhost` EVENT `trade` ON SCHEDULE EVERY 1 WEEK STARTS '2022-09-05 17:00:13' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
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
END$$

DROP EVENT IF EXISTS `sendInbox`$$
CREATE DEFINER=`root`@`localhost` EVENT `sendInbox` ON SCHEDULE EVERY 1 WEEK STARTS '2022-09-05 16:55:09' ENDS '2022-10-05 16:55:09' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
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
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
