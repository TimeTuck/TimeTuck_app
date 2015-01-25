-- phpMyAdmin SQL Dump
-- version 4.2.10
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 25, 2015 at 08:05 PM
-- Server version: 5.5.38
-- PHP Version: 5.6.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `timetuck_main`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `session_create`(IN `uid` INT(10), IN `k` CHAR(36), IN `sec` CHAR(36), IN `date` DATETIME)
BEGIN
INSERT INTO user_sessions(user_id, skey, secret, updated) VALUES(uid, k, sec, date );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_get_user`(IN `k` CHAR(36), IN `sec` CHAR(36))
    NO SQL
BEGIN
SELECT u.* FROM users u 
	INNER JOIN user_sessions us ON u.id = us.user_id 
    WHERE us.skey = k AND us.secret = sec AND u.active = TRUE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_logout`(IN `k` CHAR(36), IN `sec` CHAR(36))
    NO SQL
BEGIN
DELETE FROM user_sessions WHERE skey=k AND secret=sec;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_update`(IN `k` CHAR(36), IN `sec` CHAR(36), IN `dt` DATETIME)
BEGIN
UPDATE user_sessions SET secret=sec, updated=dt WHERE skey = k;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_check_info_exists`(IN `uname` VARCHAR(100), IN `phone` VARCHAR(15), IN `em` VARCHAR(200))
BEGIN
DECLARE ucount int;
DECLARE pcount int;
DECLARE ecount int;

SET ucount = (SELECT COUNT(*) FROM users WHERE username = uname);
SET pcount = (SELECT COUNT(*) FROM users WHERE phone_number = phone);
SET ecount = (SELECT COUNT(*) FROM users WHERE email = em);

SELECT CASE WHEN ucount > 0 THEN TRUE ELSE FALSE END AS username,
	   CASE WHEN pcount > 0 THEN TRUE ELSE FALSE END AS phonenumber,
       CASE WHEN ecount > 0 THEN TRUE ELSE FALSE END AS email;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_get_login`(IN `ue` VARCHAR(200))
BEGIN
SELECT * FROM users WHERE username = ue OR email = ue;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_save`(IN `uname` VARCHAR(100), IN `passwd` VARCHAR(200), IN `phone` VARCHAR(15), IN `created_time` DATETIME, IN `em` VARCHAR(200))
BEGIN
	insert into users(username, password, phone_number, email, created) VALUES(uname, passwd, phone, em, created_time);
    select id from users where username = uname;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
`id` int(10) unsigned NOT NULL,
  `username` varchar(100) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `email` varchar(200) NOT NULL,
  `password` varchar(200) NOT NULL,
  `created` datetime NOT NULL,
  `activated` tinyint(1) NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE `user_sessions` (
  `user_id` int(10) unsigned NOT NULL,
  `skey` char(36) NOT NULL,
  `secret` char(36) NOT NULL,
  `updated` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `username` (`username`), ADD UNIQUE KEY `phone_number` (`phone_number`), ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_sessions`
--
ALTER TABLE `user_sessions`
 ADD KEY `user_id` (`user_id`,`skey`,`secret`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=106;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `user_sessions`
--
ALTER TABLE `user_sessions`
ADD CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;