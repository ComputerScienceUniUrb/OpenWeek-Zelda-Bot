-- phpMyAdmin SQL Dump
-- version 4.6.0
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 21, 2016 at 06:46 PM
-- Server version: 5.5.46-0+deb8u1
-- PHP Version: 5.6.17-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `treasurehuntbot`
--

-- --------------------------------------------------------

--
-- Table structure for table `assigned_locations`
--

CREATE TABLE `assigned_locations` (
  `game_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `assigned_on` datetime NOT NULL,
  `reached_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `assigned_riddles`
--

CREATE TABLE `assigned_riddles` (
  `game_id` int(11) NOT NULL,
  `riddle_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `assigned_on` datetime NOT NULL,
  `last_answer_on` datetime DEFAULT NULL,
  `solved_on` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `event_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `registered_on` datetime NOT NULL,
  `num_steps` tinyint(3) UNSIGNED NOT NULL DEFAULT '10',
  `organizer_id` int(10) UNSIGNED NOT NULL,
  `min_avg_distance` float DEFAULT NULL COMMENT 'Minimum average distance between locations (in kms)',
  `telegram_channel` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `game_id` int(10) UNSIGNED NOT NULL,
  `event_id` int(10) UNSIGNED NOT NULL,
  `status` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_lat` float DEFAULT NULL,
  `location_lng` float DEFAULT NULL,
  `organizer_id` int(10) UNSIGNED DEFAULT NULL,
  `organizer_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `telegram_channel` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tmp_location_lat` float DEFAULT NULL,
  `tmp_location_lng` float DEFAULT NULL,
  `tmp_location_image_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tmp_location_description` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `game_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `participants_count` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',
  `photo_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Path to the group''s photo',
  `state` tinyint(2) UNSIGNED NOT NULL DEFAULT '0',
  `registration` datetime NOT NULL COMMENT 'Original generation timestamp',
  `last_state_change` datetime NOT NULL COMMENT 'Timestamp of last state change'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `identities`
--

CREATE TABLE `identities` (
  `id` int(11) NOT NULL COMMENT 'Internal ID',
  `telegram_id` int(11) NOT NULL,
  `first_name` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `full_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `first_seen_on` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `game_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `code` binary(16) NOT NULL,
  `internal_note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lat` float NOT NULL,
  `lng` float NOT NULL,
  `image_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `timestamp` datetime NOT NULL,
  `tag` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message` text COLLATE utf8_unicode_ci NOT NULL,
  `severity` tinyint(3) UNSIGNED NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `telegram_chat_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `riddles`
--

CREATE TABLE `riddles` (
  `game_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `image_path` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `text` text COLLATE utf8_unicode_ci NOT NULL,
  `solution` text COLLATE utf8_unicode_ci NOT NULL,
  `hint` text COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assigned_locations`
--
ALTER TABLE `assigned_locations`
  ADD PRIMARY KEY (`game_id`,`location_id`,`group_id`) USING BTREE,
  ADD KEY `assloc_group_constraint` (`group_id`);

--
-- Indexes for table `assigned_riddles`
--
ALTER TABLE `assigned_riddles`
  ADD PRIMARY KEY (`game_id`,`riddle_id`,`group_id`),
  ADD KEY `assriddles_group_constraint` (`group_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `event_organizer_index` (`organizer_id`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`game_id`),
  ADD KEY `game_event_index` (`event_id`),
  ADD KEY `game_organizer_index` (`organizer_id`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`game_id`,`group_id`),
  ADD KEY `status_group_constraint` (`group_id`);

--
-- Indexes for table `identities`
--
ALTER TABLE `identities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `telegram_id` (`telegram_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`game_id`,`id`),
  ADD UNIQUE KEY `location_code_index` (`game_id`,`code`) USING BTREE;

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD KEY `timestamp` (`timestamp`),
  ADD KEY `tag` (`tag`),
  ADD KEY `telegram_chat_id` (`telegram_chat_id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indexes for table `riddles`
--
ALTER TABLE `riddles`
  ADD PRIMARY KEY (`game_id`,`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `event_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `game_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `identities`
--
ALTER TABLE `identities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Internal ID';
--
-- Constraints for dumped tables
--

--
-- Constraints for table `assigned_locations`
--
ALTER TABLE `assigned_locations`
  ADD CONSTRAINT `assloc_group_constraint` FOREIGN KEY (`group_id`) REFERENCES `identities` (`id`),
  ADD CONSTRAINT `assloc_location_constraint` FOREIGN KEY (`game_id`,`location_id`) REFERENCES `locations` (`game_id`, `id`);

--
-- Constraints for table `assigned_riddles`
--
ALTER TABLE `assigned_riddles`
  ADD CONSTRAINT `assriddles_group_constraint` FOREIGN KEY (`group_id`) REFERENCES `identities` (`id`),
  ADD CONSTRAINT `assriddles_riddle_constraint` FOREIGN KEY (`game_id`,`riddle_id`) REFERENCES `riddles` (`game_id`, `id`);

--
-- Constraints for table `games`
--
ALTER TABLE `games`
  ADD CONSTRAINT `game_event_constraint` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE;

--
-- Constraints for table `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `status_group_constraint` FOREIGN KEY (`group_id`) REFERENCES `identities` (`id`);

--
-- Constraints for table `log`
--
ALTER TABLE `log`
  ADD CONSTRAINT `log_group_constraint` FOREIGN KEY (`group_id`) REFERENCES `identities` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;
