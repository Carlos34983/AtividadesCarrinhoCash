-- MySQL dump 10.13  Distrib 9.7.2, for Linux (x86_64)
--
-- Host: localhost    Database: ticketcore
-- ------------------------------------------------------
-- Server version	9.7.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `ticketcore`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ticketcore` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ticketcore`;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entity_id` bigint unsigned NOT NULL,
  `operation` enum('insert','update','delete') COLLATE utf8mb4_unicode_ci NOT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `actor_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_audit_entity` (`entity_type`,`entity_id`),
  KEY `idx_audit_created` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,'orders',1,'insert',NULL,'{\"total\": 200.00, \"status\": \"confirmed\", \"order_number\": \"TC-2026-0001\"}',1,'2026-10-14 22:52:27'),(2,'payments',1,'insert',NULL,'{\"amount\": 200.00, \"status\": \"approved\", \"transaction_reference\": \"TX-0001\"}',1,'2026-10-14 22:52:27');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `check_ins`
--

DROP TABLE IF EXISTS `check_ins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `check_ins` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint unsigned NOT NULL,
  `gate` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_id` bigint unsigned DEFAULT NULL,
  `result` enum('accepted','rejected') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checked_in_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_checkins_ticket_date` (`ticket_id`,`checked_in_at`),
  CONSTRAINT `fk_checkins_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `check_ins`
--

LOCK TABLES `check_ins` WRITE;
/*!40000 ALTER TABLE `check_ins` DISABLE KEYS */;
INSERT INTO `check_ins` VALUES (1,1,'Portao A',1,'accepted',NULL,'2026-10-14 22:52:27'),(2,1,'Portao A',1,'rejected','Ingresso ja utilizado','2026-10-14 22:52:27'),(3,3,'Portao B',2,'accepted',NULL,'2026-10-14 22:52:27');
/*!40000 ALTER TABLE `check_ins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('active','inactive','blocked') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `document` (`document`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Ana Souza','ana@example.com','10000000001','41999990001','2026-10-14 22:52:27','2026-10-14 22:52:27','active'),(2,'Bruno Lima','bruno@example.com','10000000002','41999990002','2026-10-14 22:52:27','2026-10-14 22:52:27','active'),(3,'Carla Mendes','carla@example.com','10000000003','41999990003','2026-10-14 22:52:27','2026-10-14 22:52:27','active'),(4,'Diego Alves','diego@example.com','10000000004','41999990004','2026-10-14 22:52:27','2026-10-14 22:52:27','inactive'),(5,'Eduarda Costa','eduarda@example.com','10000000005','41999990005','2026-10-14 22:52:27','2026-10-14 22:52:27','active');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_sector_prices`
--

DROP TABLE IF EXISTS `event_sector_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_sector_prices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event_id` bigint unsigned NOT NULL,
  `sector_id` bigint unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `total_quantity` int unsigned NOT NULL,
  `available_quantity` int unsigned NOT NULL,
  `sales_starts_at` datetime NOT NULL,
  `sales_ends_at` datetime NOT NULL,
  `status` enum('scheduled','active','sold_out','closed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'scheduled',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_prices_sector` (`sector_id`),
  KEY `idx_prices_event_sector` (`event_id`,`sector_id`),
  CONSTRAINT `fk_prices_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  CONSTRAINT `fk_prices_sector` FOREIGN KEY (`sector_id`) REFERENCES `sectors` (`id`),
  CONSTRAINT `event_sector_prices_chk_1` CHECK ((`price` >= 0)),
  CONSTRAINT `event_sector_prices_chk_2` CHECK ((`total_quantity` > 0)),
  CONSTRAINT `event_sector_prices_chk_3` CHECK ((`available_quantity` <= `total_quantity`)),
  CONSTRAINT `event_sector_prices_chk_4` CHECK ((`sales_ends_at` > `sales_starts_at`))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_sector_prices`
--

LOCK TABLES `event_sector_prices` WRITE;
/*!40000 ALTER TABLE `event_sector_prices` DISABLE KEYS */;
INSERT INTO `event_sector_prices` VALUES (1,1,1,'Primeiro lote - Pista',100.00,5000,5000,'2026-10-01 09:00:00','2026-11-01 23:59:00','active','2026-10-14 22:52:27','2026-10-14 22:52:27'),(2,1,1,'Segundo lote - Pista',130.00,2000,2000,'2026-11-02 00:00:00','2026-11-20 20:00:00','scheduled','2026-10-14 22:52:27','2026-10-14 22:52:27'),(3,1,2,'Camarote',250.00,1000,1000,'2026-10-01 09:00:00','2026-11-20 20:00:00','active','2026-10-14 22:52:27','2026-10-14 22:52:27'),(4,2,3,'Ingresso inteiro',80.00,1200,1200,'2026-10-01 09:00:00','2026-12-05 12:00:00','active','2026-10-14 22:52:27','2026-10-14 22:52:27'),(5,2,4,'Ingresso VIP',150.00,400,400,'2026-10-01 09:00:00','2026-12-05 12:00:00','active','2026-10-14 22:52:27','2026-10-14 22:52:27'),(6,1,1,'LOTE TESTE CONCORRENCIA',50.00,10,9,'2026-10-01 09:00:00','2026-11-20 20:00:00','active','2026-11-10 22:15:42','2026-11-10 22:19:43'),(7,1,1,'LOTE TESTE CONCORRENCIA 50',50.00,10,0,'2026-10-01 09:00:00','2026-11-20 20:00:00','sold_out','2026-11-10 22:20:44','2026-11-10 22:28:17');
/*!40000 ALTER TABLE `event_sector_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venue_id` bigint unsigned NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `starts_at` datetime NOT NULL,
  `ends_at` datetime NOT NULL,
  `sales_starts_at` datetime NOT NULL,
  `sales_ends_at` datetime NOT NULL,
  `status` enum('draft','published','cancelled','finished') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_events_venue` (`venue_id`),
  CONSTRAINT `fk_events_venue` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`),
  CONSTRAINT `events_chk_1` CHECK ((`ends_at` > `starts_at`)),
  CONSTRAINT `events_chk_2` CHECK ((`sales_ends_at` > `sales_starts_at`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
INSERT INTO `events` VALUES (1,1,'Festival de Musica 2026','Festival musical de exemplo','2026-11-20 18:00:00','2026-11-20 23:59:00','2026-10-01 09:00:00','2026-11-20 20:00:00','published','2026-10-14 22:52:27','2026-10-14 22:52:27'),(2,2,'Encontro de Tecnologia','Evento de tecnologia de exemplo','2026-12-05 09:00:00','2026-12-05 18:00:00','2026-10-01 09:00:00','2026-12-05 12:00:00','published','2026-10-14 22:52:27','2026-10-14 22:52:27');
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `event_sector_price_id` bigint unsigned NOT NULL,
  `quantity` int unsigned NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_items_price` (`event_sector_price_id`),
  KEY `idx_items_order` (`order_id`),
  CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_items_price` FOREIGN KEY (`event_sector_price_id`) REFERENCES `event_sector_prices` (`id`),
  CONSTRAINT `order_items_chk_1` CHECK ((`quantity` > 0)),
  CONSTRAINT `order_items_chk_2` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `order_items_chk_3` CHECK ((`discount` >= 0)),
  CONSTRAINT `order_items_chk_4` CHECK ((`total` >= 0)),
  CONSTRAINT `order_items_chk_5` CHECK ((`discount` <= (`unit_price` * `quantity`)))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,2,100.00,0.00,200.00,'2026-10-14 22:52:27'),(2,2,3,1,250.00,0.00,250.00,'2026-10-14 22:52:27'),(3,3,4,2,80.00,10.00,150.00,'2026-10-14 22:52:27'),(4,4,4,1,80.00,0.00,80.00,'2026-10-14 22:52:27'),(5,5,6,1,50.00,0.00,50.00,'2026-11-10 22:19:43'),(6,6,7,1,50.00,0.00,50.00,'2026-11-10 22:25:14'),(7,7,7,1,50.00,0.00,50.00,'2026-11-10 22:27:31'),(8,8,7,1,50.00,0.00,50.00,'2026-11-10 22:27:31'),(9,9,7,1,50.00,0.00,50.00,'2026-11-10 22:28:16'),(10,10,7,1,50.00,0.00,50.00,'2026-11-10 22:28:16'),(11,11,7,1,50.00,0.00,50.00,'2026-11-10 22:28:16'),(12,12,7,1,50.00,0.00,50.00,'2026-11-10 22:28:16'),(13,13,7,1,50.00,0.00,50.00,'2026-11-10 22:28:16'),(14,14,7,1,50.00,0.00,50.00,'2026-11-10 22:28:17'),(15,15,7,1,50.00,0.00,50.00,'2026-11-10 22:28:17');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` bigint unsigned NOT NULL,
  `order_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','confirmed','cancelled','expired') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `subtotal` decimal(10,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `expires_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `idx_orders_customer_status` (`customer_id`,`status`),
  CONSTRAINT `fk_orders_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `orders_chk_1` CHECK ((`subtotal` >= 0)),
  CONSTRAINT `orders_chk_2` CHECK ((`discount` >= 0)),
  CONSTRAINT `orders_chk_3` CHECK ((`total` >= 0)),
  CONSTRAINT `orders_chk_4` CHECK ((`discount` <= `subtotal`))
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'TC-2026-0001','confirmed',200.00,0.00,200.00,NULL,'2026-10-14 22:52:27','2026-10-14 22:52:27'),(2,2,'TC-2026-0002','pending',250.00,0.00,250.00,'2026-10-15 20:00:00','2026-10-14 22:52:27','2026-10-14 22:52:27'),(3,3,'TC-2026-0003','confirmed',160.00,10.00,150.00,NULL,'2026-10-14 22:52:27','2026-10-14 22:52:27'),(4,5,'TC-2026-0004','cancelled',80.00,0.00,80.00,NULL,'2026-10-14 22:52:27','2026-10-14 22:52:27'),(5,1,'TESTE-d4123faa-dd54-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:19:43','2026-11-10 22:19:43'),(6,1,'TESTE-99729276-dd55-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:25:14','2026-11-10 22:25:14'),(7,2,'TESTE-eb1072b0-dd55-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:27:31','2026-11-10 22:27:31'),(8,3,'TESTE-eb15b4c5-dd55-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:27:31','2026-11-10 22:27:31'),(9,5,'TESTE-0602803d-dd56-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:28:16','2026-11-10 22:28:16'),(10,5,'TESTE-0613a066-dd56-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:28:16','2026-11-10 22:28:16'),(11,1,'TESTE-0649144c-dd56-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:28:16','2026-11-10 22:28:16'),(12,2,'TESTE-0662ae87-dd56-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:28:16','2026-11-10 22:28:16'),(13,4,'TESTE-066a87fb-dd56-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:28:16','2026-11-10 22:28:16'),(14,3,'TESTE-0675b192-dd56-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:28:17','2026-11-10 22:28:17'),(15,1,'TESTE-067cd17d-dd56-11f1-b783-56d3940ec9e6','confirmed',50.00,0.00,50.00,NULL,'2026-11-10 22:28:17','2026-11-10 22:28:17');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint unsigned NOT NULL,
  `transaction_reference` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idempotency_key` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('pending','approved','rejected','cancelled','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `paid_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idempotency_key` (`idempotency_key`),
  UNIQUE KEY `transaction_reference` (`transaction_reference`),
  KEY `idx_payments_order_status` (`order_id`,`status`),
  KEY `idx_payments_status_paid_at` (`status`,`paid_at`),
  CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `payments_chk_1` CHECK ((`amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,'TX-0001','IDEMP-0001','PIX',200.00,'approved','2026-10-14 22:52:27','2026-10-14 22:52:27','2026-10-14 22:52:27'),(2,2,NULL,'IDEMP-0002','CREDIT_CARD',250.00,'pending',NULL,'2026-10-14 22:52:27','2026-10-14 22:52:27'),(3,3,'TX-0003','IDEMP-0003','PIX',150.00,'approved','2026-10-14 22:52:27','2026-10-14 22:52:27','2026-10-14 22:52:27'),(4,4,'TX-0004','IDEMP-0004','PIX',80.00,'cancelled',NULL,'2026-10-14 22:52:27','2026-10-14 22:52:27'),(6,5,NULL,'TESTE-IDEMPOTENCIA-001','test',50.00,'approved','2026-11-10 22:19:43','2026-11-10 22:19:43','2026-11-10 22:19:43'),(7,6,NULL,'CONCORRENCIA-1','test',50.00,'approved','2026-11-10 22:25:14','2026-11-10 22:25:14','2026-11-10 22:25:14'),(8,7,NULL,'CONCORRENCIA-2','test',50.00,'approved','2026-11-10 22:27:31','2026-11-10 22:27:31','2026-11-10 22:27:31'),(9,8,NULL,'CONCORRENCIA-3','test',50.00,'approved','2026-11-10 22:27:31','2026-11-10 22:27:31','2026-11-10 22:27:31'),(10,9,NULL,'CONCORRENCIA-5','test',50.00,'approved','2026-11-10 22:28:16','2026-11-10 22:28:16','2026-11-10 22:28:16'),(11,10,NULL,'CONCORRENCIA-50','test',50.00,'approved','2026-11-10 22:28:16','2026-11-10 22:28:16','2026-11-10 22:28:16'),(12,11,NULL,'CONCORRENCIA-6','test',50.00,'approved','2026-11-10 22:28:16','2026-11-10 22:28:16','2026-11-10 22:28:16'),(13,12,NULL,'CONCORRENCIA-37','test',50.00,'approved','2026-11-10 22:28:16','2026-11-10 22:28:16','2026-11-10 22:28:16'),(14,13,NULL,'CONCORRENCIA-4','test',50.00,'approved','2026-11-10 22:28:16','2026-11-10 22:28:16','2026-11-10 22:28:16'),(15,14,NULL,'CONCORRENCIA-38','test',50.00,'approved','2026-11-10 22:28:17','2026-11-10 22:28:17','2026-11-10 22:28:17'),(16,15,NULL,'CONCORRENCIA-31','test',50.00,'approved','2026-11-10 22:28:17','2026-11-10 22:28:17','2026-11-10 22:28:17');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refunds`
--

DROP TABLE IF EXISTS `refunds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refunds` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_id` bigint unsigned NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','approved','rejected','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `provider_reference` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requested_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `provider_reference` (`provider_reference`),
  KEY `idx_refunds_payment_status` (`payment_id`,`status`),
  CONSTRAINT `fk_refunds_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`),
  CONSTRAINT `refunds_chk_1` CHECK ((`amount` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refunds`
--

LOCK TABLES `refunds` WRITE;
/*!40000 ALTER TABLE `refunds` DISABLE KEYS */;
INSERT INTO `refunds` VALUES (1,3,20.00,'Reembolso parcial de exemplo','completed','REF-0001','2026-10-14 22:52:27','2026-10-14 22:52:27');
/*!40000 ALTER TABLE `refunds` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sectors`
--

DROP TABLE IF EXISTS `sectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sectors` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `venue_id` bigint unsigned NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `capacity` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `venue_id` (`venue_id`,`name`),
  CONSTRAINT `fk_sectors_venue` FOREIGN KEY (`venue_id`) REFERENCES `venues` (`id`),
  CONSTRAINT `sectors_chk_1` CHECK ((`capacity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sectors`
--

LOCK TABLES `sectors` WRITE;
/*!40000 ALTER TABLE `sectors` DISABLE KEYS */;
INSERT INTO `sectors` VALUES (1,1,'Pista','Acesso geral',7000,'2026-10-14 22:52:27','active'),(2,1,'Camarote','Area reservada',3000,'2026-10-14 22:52:27','active'),(3,2,'Plateia','Assentos gerais',1500,'2026-10-14 22:52:27','active'),(4,2,'VIP','Area reservada',500,'2026-10-14 22:52:27','active');
/*!40000 ALTER TABLE `sectors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint unsigned NOT NULL,
  `ticket_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `holder_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `holder_document` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('issued','used','cancelled','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'issued',
  `issued_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ticket_code` (`ticket_code`),
  KEY `idx_tickets_item_status` (`order_item_id`,`status`),
  CONSTRAINT `fk_tickets_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
INSERT INTO `tickets` VALUES (1,1,'TC-TICKET-0001','Ana Souza','10000000001','issued','2026-10-14 22:52:27','2026-10-14 22:52:27'),(2,1,'TC-TICKET-0002','Ana Souza','10000000001','issued','2026-10-14 22:52:27','2026-10-14 22:52:27'),(3,2,'TC-TICKET-0003','Bruno Lima','10000000002','issued','2026-10-14 22:52:27','2026-10-14 22:52:27'),(4,3,'TC-TICKET-0004','Carla Mendes','10000000003','issued','2026-10-14 22:52:27','2026-10-14 22:52:27'),(5,3,'TC-TICKET-0005','Carla Mendes','10000000003','issued','2026-10-14 22:52:27','2026-10-14 22:52:27'),(6,4,'TC-TICKET-0006','Eduarda Costa','10000000005','cancelled','2026-10-14 22:52:27','2026-10-14 22:52:27'),(9,5,'TKT-d412f5c0-dd54-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:19:43','2026-11-10 22:19:43'),(10,6,'TKT-99739912-dd55-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:25:14','2026-11-10 22:25:14'),(11,7,'TKT-eb1274f9-dd55-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:27:31','2026-11-10 22:27:31'),(12,8,'TKT-eb169a29-dd55-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:27:31','2026-11-10 22:27:31'),(13,9,'TKT-0603c22e-dd56-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:28:16','2026-11-10 22:28:16'),(14,10,'TKT-06203477-dd56-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:28:16','2026-11-10 22:28:16'),(15,11,'TKT-064d81df-dd56-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:28:16','2026-11-10 22:28:16'),(16,12,'TKT-0662ff43-dd56-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:28:16','2026-11-10 22:28:16'),(17,13,'TKT-066ba091-dd56-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:28:16','2026-11-10 22:28:16'),(18,14,'TKT-0678a67d-dd56-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:28:17','2026-11-10 22:28:17'),(19,15,'TKT-06bfa855-dd56-11f1-b783-56d3940ec9e6',NULL,NULL,'issued','2026-11-10 22:28:17','2026-11-10 22:28:17');
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `venues`
--

DROP TABLE IF EXISTS `venues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venues` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacity` int unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  CONSTRAINT `venues_chk_1` CHECK ((`capacity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `venues`
--

LOCK TABLES `venues` WRITE;
/*!40000 ALTER TABLE `venues` DISABLE KEYS */;
INSERT INTO `venues` VALUES (1,'Arena Central','Rua das Flores, 100','Curitiba','PR',10000,'2026-10-14 22:52:27','active'),(2,'Espaco Cultural Sul','Avenida Brasil, 250','Guarapuava','PR',2000,'2026-10-14 22:52:27','active');
/*!40000 ALTER TABLE `venues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ticketcore'
--

--
-- Dumping routines for database 'ticketcore'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_comprar_ingresso_teste` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_comprar_ingresso_teste`(
    IN p_lot_id BIGINT UNSIGNED,
    IN p_customer_id BIGINT UNSIGNED,
    IN p_idempotency_key VARCHAR(150)
)
BEGIN
    DECLARE v_order_id BIGINT UNSIGNED;
    DECLARE v_item_id BIGINT UNSIGNED;
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_existing_count INT DEFAULT 0;
    DECLARE v_order_number VARCHAR(50);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_existing_count
    FROM payments
    WHERE idempotency_key = p_idempotency_key;

    IF v_existing_count > 0 THEN
        ROLLBACK;
        SELECT 'SOLICITACAO_JA_PROCESSADA' AS resultado;
    ELSE
        UPDATE event_sector_prices
        SET available_quantity = available_quantity - 1
        WHERE id = p_lot_id
          AND status = 'active'
          AND available_quantity > 0;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'INGRESSOS ESGOTADOS';
        END IF;

        SELECT price INTO v_price
        FROM event_sector_prices
        WHERE id = p_lot_id;

        SET v_order_number = CONCAT('TESTE-', UUID());

        INSERT INTO orders (
            customer_id, order_number, status,
            subtotal, discount, total
        ) VALUES (
            p_customer_id, v_order_number, 'pending',
            v_price, 0, v_price
        );

        SET v_order_id = LAST_INSERT_ID();

        INSERT INTO order_items (
            order_id, event_sector_price_id,
            quantity, unit_price, discount, total
        ) VALUES (
            v_order_id, p_lot_id, 1, v_price, 0, v_price
        );

        SET v_item_id = LAST_INSERT_ID();

        INSERT INTO payments (
            order_id, idempotency_key, method,
            amount, status, paid_at
        ) VALUES (
            v_order_id, p_idempotency_key, 'test',
            v_price, 'approved', NOW()
        );

        INSERT INTO tickets (
            order_item_id, ticket_code, status
        ) VALUES (
            v_item_id, CONCAT('TKT-', UUID()), 'issued'
        );

        UPDATE orders
        SET status = 'confirmed'
        WHERE id = v_order_id;

        UPDATE event_sector_prices
        SET status = 'sold_out'
        WHERE id = p_lot_id AND available_quantity = 0;

        COMMIT;

        SELECT 'COMPRA_CONFIRMADA' AS resultado,
               v_order_id AS pedido_id,
               v_item_id AS item_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `teste_execucao_sql` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `teste_execucao_sql`()
BEGIN
    SELECT 'EXECUCAO_OK' AS resultado;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-16 22:03:38
