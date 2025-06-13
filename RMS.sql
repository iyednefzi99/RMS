-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 15 mai 2025 à 00:51
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `restaurant_management`
--

-- --------------------------------------------------------

--
-- Structure de la table `accounts`
--

CREATE TABLE `accounts` (
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `status` enum('ACTIVE','CLOSED','CANCELED','BLACKLISTED','SUSPENDED','PENDING','FROZEN','INACTIVE','ARCHIVED','DELETED','VERIFIED','UNVERIFIED','LOCKED','REINSTATED','EXPIRED','TERMINATED','UNDER_REVIEW','DORMANT','SUSPICIOUS') DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `accounts`
--

INSERT INTO `accounts` (`username`, `password`, `email`, `status`, `is_deleted`, `deleted_at`, `created_at`, `updated_at`) VALUES
('AyaZ1501', 'AyaZ1501185*', 'nefzi@gjhjkj.xcxss', 'ACTIVE', 0, NULL, '2025-05-13 20:39:46', '2025-05-13 21:06:25'),
('AyaZnefzi', 'AyaZ15151', 'nefzi@gma.cf', 'ACTIVE', 0, NULL, '2025-05-13 02:10:12', '2025-05-13 22:00:27'),
('cbvsdf', 'Ayazsdfsdf6415', 'vccfghgf@gmail.com', 'ACTIVE', 0, NULL, '2025-05-13 02:11:12', '2025-05-13 22:00:29'),
('ChefMichael', 'SecurePass123!', 'chef.michael@restaurant.com', 'ACTIVE', 0, NULL, '2025-05-14 22:50:53', '2025-05-14 22:50:53'),
('cxxxxxxxxxxv', 'aeze11240*/A', 'cxv@k.g', 'ACTIVE', 0, NULL, '2025-05-13 02:10:44', '2025-05-13 02:10:44'),
('DinerRegular1', 'DinerPass789*', 'regular.customer1@email.com', 'VERIFIED', 0, NULL, '2025-05-14 22:50:53', '2025-05-14 22:50:53'),
('HostSarah', 'Welcome456$', 'sarah.host@restaurant.com', 'ACTIVE', 0, NULL, '2025-05-14 22:50:53', '2025-05-14 22:50:53');

-- --------------------------------------------------------

--
-- Structure de la table `customers`
--

CREATE TABLE `customers` (
  `id` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `account_username` varchar(50) NOT NULL,
  `last_visited` timestamp NOT NULL DEFAULT current_timestamp(),
  `client_discount` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `customers`
--

INSERT INTO `customers` (`id`, `name`, `phone`, `account_username`, `last_visited`, `client_discount`, `created_at`, `updated_at`) VALUES
('15223', 'ayaz', '2587413690', 'AyaZnefzi', '2025-05-14 22:18:01', 10, '2025-05-14 22:18:01', '2025-05-14 22:18:01'),
('CUST-1001', 'Michael Johnson', '5551234567', 'DinerRegular1', '2025-05-14 22:51:01', 5, '2025-05-14 22:51:01', '2025-05-14 22:51:01'),
('CUST-1002', 'Emily Wilson', '5559876543', 'HostSarah', '2025-05-14 22:51:01', 0, '2025-05-14 22:51:01', '2025-05-14 22:51:01'),
('CUST-1003', 'Robert Chen', '5554567890', 'ChefMichael', '2025-05-14 22:51:01', 10, '2025-05-14 22:51:01', '2025-05-14 22:51:01'),
('sdfsdf0', 'fgqfdgfgdfg', '1234567890', 'cbvsdf', '2025-05-13 22:00:45', 0, '2025-05-13 22:00:45', '2025-05-13 22:00:45');

-- --------------------------------------------------------

--
-- Structure de la table `employees`
--

CREATE TABLE `employees` (
  `id` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `account_username` varchar(50) NOT NULL,
  `date_joined` date NOT NULL,
  `role` enum('WAITER','RECEPTIONIST','MANAGER') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `employees`
--

INSERT INTO `employees` (`id`, `name`, `phone`, `account_username`, `date_joined`, `role`, `created_at`, `updated_at`) VALUES
('EMP-0001', 'John Doe', '1234567890', 'AyaZ1501', '2025-01-01', 'WAITER', '2025-05-13 23:02:37', '2025-05-13 23:02:37'),
('EMP-0002', 'Jane Smith', '0987654321', 'AyaZnefzi', '2025-01-15', 'MANAGER', '2025-05-13 23:02:37', '2025-05-13 23:02:37'),
('EMP-0003', 'Michael Brown', '5551112233', 'ChefMichael', '2025-02-10', 'MANAGER', '2025-05-14 22:51:09', '2025-05-14 22:51:09'),
('EMP-0004', 'Sarah Johnson', '5554445566', 'HostSarah', '2025-03-15', 'RECEPTIONIST', '2025-05-14 22:51:09', '2025-05-14 22:51:09');

-- --------------------------------------------------------

--
-- Structure de la table `reservations`
--

CREATE TABLE `reservations` (
  `reservation_id` varchar(20) NOT NULL,
  `customer_id` varchar(20) NOT NULL,
  `table_id` varchar(20) NOT NULL,
  `reservation_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `party_size` int(11) NOT NULL,
  `special_requests` text DEFAULT NULL,
  `created_by` varchar(20) NOT NULL,
  `status` enum('PENDING','CONFIRMED','CANCELED','ABANDONED','COMPLETED','NO_SHOW','MODIFIED','EXPIRED','WAITLISTED','REJECTED','IN_PROGRESS','VERIFIED','PARTIALLY_CONFIRMED','AWAITING_PAYMENT','CANCELLED_BY_USER','CANCELLED_BY_SYSTEM','RESCHEDULED') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `reservations`
--

INSERT INTO `reservations` (`reservation_id`, `customer_id`, `table_id`, `reservation_time`, `party_size`, `special_requests`, `created_by`, `status`, `created_at`, `updated_at`) VALUES
('RES-789012', 'CUST-1001', 'TBL-78901234', '2025-05-20 18:00:00', 4, 'Anniversary celebration', 'EMP-0004', 'CONFIRMED', '2025-05-14 22:51:25', '2025-05-14 22:51:25'),
('RES-789013', 'CUST-1002', 'TBL-78901235', '2025-05-21 19:30:00', 5, 'Vegetarian options needed', 'EMP-0003', 'PENDING', '2025-05-14 22:51:25', '2025-05-14 22:51:25'),
('RES-789014', 'CUST-1003', 'TBL-78901236', '2025-05-22 17:00:00', 2, NULL, 'EMP-0004', 'CONFIRMED', '2025-05-14 22:51:25', '2025-05-14 22:51:25');

-- --------------------------------------------------------

--
-- Structure de la table `tables`
--

CREATE TABLE `tables` (
  `table_id` varchar(20) NOT NULL,
  `max_capacity` int(11) NOT NULL,
  `location_identifier` int(11) NOT NULL,
  `status` enum('FREE','RESERVED','OCCUPIED','CANCELED','WAITLISTED','IN_SERVICE','OUT_OF_SERVICE','PENDING','UNAVAILABLE','READY_FOR_CLEANING','BEING_CLEANED','BOOKED','CHECKED_OUT','TEMPORARILY_CLOSED','RESERVED_FOR_EVENT','PARTIALLY_OCCUPIED') NOT NULL DEFAULT 'FREE',
  `seat_type` enum('REGULAR','BOOTH','BAR','HIGH_CHAIR','WHEELCHAIR_ACCESSIBLE') NOT NULL DEFAULT 'REGULAR',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `tables`
--

INSERT INTO `tables` (`table_id`, `max_capacity`, `location_identifier`, `status`, `seat_type`, `created_at`, `updated_at`) VALUES
('TBL-558104bf', 56, 200, 'RESERVED', 'BAR', '2025-05-14 22:04:14', '2025-05-14 22:31:19'),
('TBL-78901234', 4, 101, 'FREE', 'REGULAR', '2025-05-14 22:51:17', '2025-05-14 22:51:17'),
('TBL-78901235', 6, 102, 'FREE', 'BOOTH', '2025-05-14 22:51:17', '2025-05-14 22:51:17'),
('TBL-78901236', 2, 103, 'FREE', 'BAR', '2025-05-14 22:51:17', '2025-05-14 22:51:17'),
('TBL-78901237', 8, 104, 'FREE', 'WHEELCHAIR_ACCESSIBLE', '2025-05-14 22:51:17', '2025-05-14 22:51:17'),
('TBL-bfafaa72', 55, 300, 'RESERVED', 'BAR', '2025-05-11 12:15:33', '2025-05-14 22:19:01'),
('TBL-e55e2851', 5, 200, 'FREE', 'BAR', '2025-05-13 22:28:45', '2025-05-14 22:18:34');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`username`),
  ADD UNIQUE KEY `email_unique` (`email`);

--
-- Index pour la table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_username` (`account_username`);

--
-- Index pour la table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_username` (`account_username`);

--
-- Index pour la table `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`table_id`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`account_username`) REFERENCES `accounts` (`username`);

--
-- Contraintes pour la table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`account_username`) REFERENCES `accounts` (`username`);

--
-- Contraintes pour la table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `fk_reservation_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `fk_reservation_table` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
