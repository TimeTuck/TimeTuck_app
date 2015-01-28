-- phpMyAdmin SQL Dump
-- version 4.2.10
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 28, 2015 at 10:51 PM
-- Server version: 5.5.38
-- PHP Version: 5.6.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `timetuck_main`
--

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE `friends` (
  `user_primary` int(10) unsigned NOT NULL,
  `user_secondary` int(10) unsigned NOT NULL,
  `created` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `friends`
--
ALTER TABLE `friends`
 ADD UNIQUE KEY `Friend_Relation` (`user_primary`,`user_secondary`), ADD KEY `user_primary` (`user_primary`), ADD KEY `user_secondary` (`user_secondary`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `friends`
--
ALTER TABLE `friends`
ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user_primary`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`user_secondary`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;