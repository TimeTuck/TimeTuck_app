-- phpMyAdmin SQL Dump
-- version 4.2.10
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 25, 2015 at 04:09 AM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `device_token_from_session`(IN `k` CHAR(36), IN `s` CHAR(36))
    NO SQL
SELECT device_token AS result FROM user_sessions WHERE skey = k AND secret = s$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `device_token_get_all`(IN `u_id` INT(10))
    NO SQL
SELECT device_token from user_sessions WHERE user_id = u_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `device_token_update`(IN `k` CHAR(36), IN `s` CHAR(36), IN `token` CHAR(64))
    NO SQL
UPDATE user_sessions SET device_token=token WHERE skey = k AND secret = s$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_friends`(IN `u_id` INT(10))
    NO SQL
SELECT u.id, u.username, u.email, u.phone_number, u.activated, u.active
FROM friends f1 INNER JOIN friends f2 ON f1.user_secondary = f2.user_primary AND f1.user_primary = f2.user_secondary INNER JOIN users u ON f1.user_secondary = u.id WHERE f1.user_primary = u_id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_friend_requests`(IN `u_id` INT(10))
    NO SQL
SELECT u.id, u.username, u.phone_number, u.email, u.activated, u.active FROM friends f1 LEFT JOIN friends f2 ON f1.user_primary = f2.user_secondary AND f1.user_secondary = f2.user_primary INNER JOIN users u ON f1.user_primary = u.id WHERE f1.user_secondary = u_id AND f2.user_primary IS NULL$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `respond_friend_request`(IN `u_id` INT(10), IN `req_id` INT(10), IN `created_date` DATETIME, IN `accept` BOOLEAN)
    NO SQL
BEGIN
	IF ((SELECT COUNT(*) FROM friends WHERE user_primary=req_id AND user_secondary=u_id) = 1)
	THEN
    	IF (accept = TRUE)
        THEN
    		INSERT INTO friends(user_primary, user_secondary, created) VALUES(u_id, req_id, created_date);
        ELSE
        	DELETE FROM friends WHERE user_primary=req_id AND user_secondary=u_id;
        END IF;
        SELECT 1 AS result;
    ELSE
    	SELECT 0 AS result;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `search_users`(IN `u_id` INT(10), IN `search` VARCHAR(255))
    NO SQL
select u.id as id, u.username as username, u.phone_number as phone_number, u.email as email, u.activated as activated, u.active as active from 
		(SELECT id from users) as a 
    LEFT JOIN 
    	(SELECT CASE WHEN f1.user_primary = u_id THEN f1.user_secondary ELSE f1.user_primary end as id
         FROM friends f1 where f1.user_primary = u_id or f1.user_secondary = u_id)
    as b ON a.id = b.id INNER JOIN users u on a.id = u.id WHERE b.id is null AND a.id <> u_id AND u.username LIKE CONCAT(search,'%') order by u.username ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `send_friend_request`(IN `u_id` INT(10), IN `req_id` INT(10), IN `date_sent` DATETIME)
BEGIn
IF((SELECT COUNT(*) FROM friends where user_primary=u_id AND user_secondary=req_id) > 0)
THEN
	SELECT FALSE AS result;
ELSE
	INSERT INTO friends(user_primary, user_secondary, created) VALUES(u_id, req_id, date_sent);
    SELECT TRUE AS result;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_create`(IN `uid` INT(10), IN `k` CHAR(36), IN `sec` CHAR(36), IN `date` DATETIME, IN `token` CHAR(64))
BEGIN
INSERT INTO user_sessions(user_id, skey, secret, device_token, updated) VALUES(uid, k, sec, token, date );
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `timecapsule_create_sa`(IN `u_id` INT(10), IN `cap_date` DATETIME, IN `uncap_date` DATETIME, IN `filename` VARCHAR(200))
    NO SQL
BEGIN

DECLARE n_id int;
INSERT INTO timecapsule (capsule_date, uncapsule_date, owner, type, active) VALUES(cap_date, uncap_date, u_id, 'SA', 1);
SET n_id = LAST_INSERT_ID();
INSERT INTO timecapsule_sa_media (timecap_id, file_name, active) VALUES(n_id, filename, 1);
SELECT u_id AS INSERT_ID;
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
-- Table structure for table `friends`
--

CREATE TABLE `friends` (
  `user_primary` int(10) unsigned NOT NULL,
  `user_secondary` int(10) unsigned NOT NULL,
  `created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `timecapsule`
--

CREATE TABLE `timecapsule` (
`id` int(10) NOT NULL,
  `capsule_date` datetime NOT NULL,
  `uncapsule_date` datetime NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  `type` varchar(20) NOT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `timecapsule_friends`
--

CREATE TABLE `timecapsule_friends` (
  `timecap_id` int(10) NOT NULL,
  `user_id` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `timecapsule_sa_media`
--

CREATE TABLE `timecapsule_sa_media` (
  `timecap_id` int(10) NOT NULL,
  `file_name` varchar(200) NOT NULL,
  `active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE `user_sessions` (
`session_id` int(100) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `skey` char(36) NOT NULL,
  `secret` char(36) NOT NULL,
  `device_token` char(64) DEFAULT NULL,
  `updated` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
 ADD UNIQUE KEY `Friend_Relation` (`user_primary`,`user_secondary`), ADD KEY `user_primary` (`user_primary`), ADD KEY `user_secondary` (`user_secondary`);

--
-- Indexes for table `timecapsule`
--
ALTER TABLE `timecapsule`
 ADD PRIMARY KEY (`id`), ADD KEY `owner` (`owner`);

--
-- Indexes for table `timecapsule_friends`
--
ALTER TABLE `timecapsule_friends`
 ADD UNIQUE KEY `unique_row` (`timecap_id`), ADD KEY `timecap_id` (`timecap_id`,`user_id`), ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `timecapsule_sa_media`
--
ALTER TABLE `timecapsule_sa_media`
 ADD UNIQUE KEY `timecap_id` (`timecap_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `username` (`username`), ADD UNIQUE KEY `phone_number` (`phone_number`), ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_sessions`
--
ALTER TABLE `user_sessions`
 ADD PRIMARY KEY (`session_id`), ADD KEY `user_id` (`user_id`,`skey`,`secret`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `timecapsule`
--
ALTER TABLE `timecapsule`
MODIFY `id` int(10) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=138;
--
-- AUTO_INCREMENT for table `user_sessions`
--
ALTER TABLE `user_sessions`
MODIFY `session_id` int(100) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=48;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user_primary`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`user_secondary`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `timecapsule`
--
ALTER TABLE `timecapsule`
ADD CONSTRAINT `timecapsule_ibfk_1` FOREIGN KEY (`owner`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `timecapsule_friends`
--
ALTER TABLE `timecapsule_friends`
ADD CONSTRAINT `timecapsule_friends_ibfk_1` FOREIGN KEY (`timecap_id`) REFERENCES `timecapsule` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `timecapsule_friends_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_sessions`
--
ALTER TABLE `user_sessions`
ADD CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;