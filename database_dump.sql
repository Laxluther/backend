-- MySQL dump 10.13  Distrib 8.0.37, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce_db
-- ------------------------------------------------------
-- Server version	8.0.37

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
-- Current Database: `ecommerce_db`
--

/*!40000 DROP DATABASE IF EXISTS `ecommerce_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ecommerce_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `ecommerce_db`;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `address_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_type` enum('home','work','other') COLLATE utf8mb4_unicode_ci DEFAULT 'home',
  `full_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line1` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address_line2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `postal_code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'India',
  `landmark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_default` (`is_default`),
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'510a959c-410a-4ae2-943d-576f9233329e','home','Test User','9876543210','123 Test Street','Near Test Mall','Mumbai','Maharashtra','400001','India','',0,'2025-06-01 11:18:43','2025-06-01 14:45:40'),(2,'510a959c-410a-4ae2-943d-576f9233329e','home','Test User','9876543210','123 Test Street','Near Test Mall','Mumbai','Maharashtra','400001','India','',0,'2025-06-01 14:45:41','2025-06-01 14:53:33'),(3,'510a959c-410a-4ae2-943d-576f9233329e','home','Test User','9876543210','123 Test Street','Near Test Mall','Mumbai','Maharashtra','400001','India','',0,'2025-06-01 14:53:34','2025-06-01 16:21:29'),(4,'510a959c-410a-4ae2-943d-576f9233329e','home','Test User','9876543210','123 Test Street','Near Test Mall','Mumbai','Maharashtra','400001','India','',0,'2025-06-01 16:21:30','2025-06-02 11:49:24'),(5,'510a959c-410a-4ae2-943d-576f9233329e','home','Test User','9876543210','123 Test Street','Near Test Mall','Mumbai','Maharashtra','400001','India','',1,'2025-06-02 11:49:25','2025-06-02 11:49:24');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_logs`
--

DROP TABLE IF EXISTS `admin_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `admin_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` int DEFAULT NULL,
  `details` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_admin_id` (`admin_id`),
  KEY `idx_action` (`action`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_logs`
--

LOCK TABLES `admin_logs` WRITE;
/*!40000 ALTER TABLE `admin_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `admin_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('super_admin','product_manager','order_manager','customer_support') COLLATE utf8mb4_unicode_ci NOT NULL,
  `permissions` json DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES ('031e92ec-2d9d-4d47-b517-8118875d8cf5','san','sanidhyarana3@gmail.com','scrypt:32768:8:1$VHqHTcLqbX6xcmbv$f0f620d62b5cb849324ea58a401f73a364ff6ac7b9de0ebb32da4d17da98fd4b7545a29717fabccb61e26de98cbc4e11f3a26ff12322d25b9c851c7593f2cdf9','sanidhya','super_admin',NULL,'2025-06-03 17:21:37','active','2025-06-03 16:05:19','2025-06-03 17:21:36'),('admin-001','admin','admin@yourstore.com','pbkdf2:sha256:600000$95zcVnd3lW0qUifU$ede44e21344cab2fb6290cec29192137c5e1594f8201ad07919f3a58d705615d','System Administrator','super_admin',NULL,'2025-06-03 16:22:44','active','2025-06-01 11:11:33','2025-08-20 07:32:37'),('c0bb0c25-d4ab-41bd-8916-1fc7f829e058','admin1','admin@example.com','scrypt:32768:8:1$xQJvRw8Vd33KFMNv$c54895eecbd79e5208581cf2709fc9e4b96dbb2d9bd77647248a9e5b9388c1406c025a0e06fe6aac255550e21e0c404e92e8a98c49397154d98079934a9a00db','System Administrator','super_admin',NULL,NULL,'active','2025-08-20 07:33:20','2025-08-20 07:33:51');
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `unique_cart_item` (`user_id`,`product_id`,`variant_id`),
  KEY `variant_id` (`variant_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_cart_product_id` (`product_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (22,'4054f2f5-021d-442a-a332-0e78c8027686',2,NULL,1,'2025-08-16 17:12:57','2025-08-16 17:12:56'),(23,'4054f2f5-021d-442a-a332-0e78c8027686',4,NULL,1,'2025-08-16 17:13:05','2025-08-16 17:13:05');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Nuts & Dry Fruits',NULL,'Premium quality nuts and dry fruits',NULL,'active',0,'2025-06-01 11:11:33','2025-06-01 11:11:33'),(2,'Seeds',NULL,'Nutritious seeds for healthy lifestyle',NULL,'active',0,'2025-06-01 11:11:33','2025-06-01 11:11:33'),(3,'Coffee & Tea',NULL,'Premium coffee beans and tea varieties',NULL,'inactive',0,'2025-06-01 11:11:33','2025-06-04 04:36:12'),(4,'Honey & Natural Sweeteners',NULL,'Pure honey and natural sweeteners',NULL,'active',0,'2025-06-01 11:11:33','2025-06-01 11:11:33'),(5,'Spices & Herbs',NULL,'Fresh spices and aromatic herbs',NULL,'inactive',0,'2025-06-01 11:11:33','2025-06-04 04:36:53');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_verifications`
--

DROP TABLE IF EXISTS `email_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_verifications` (
  `verification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`verification_id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_token` (`token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `email_verifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_verifications`
--

LOCK TABLES `email_verifications` WRITE;
/*!40000 ALTER TABLE `email_verifications` DISABLE KEYS */;
INSERT INTO `email_verifications` VALUES (1,'510a959c-410a-4ae2-943d-576f9233329e','7d8ee2b0-b72c-4db1-aa6d-82e130566ac8','2025-06-02 15:52:00',NULL,'2025-06-01 15:52:00'),(2,'4054f2f5-021d-442a-a332-0e78c8027686','216c3346-0beb-4b08-ad38-1b55ee181b4e','2025-06-02 15:53:53',NULL,'2025-06-01 15:53:53'),(3,'510a959c-410a-4ae2-943d-576f9233329e','2427263d-17a9-4410-b671-6b83c84e8370','2025-06-02 15:53:57',NULL,'2025-06-01 15:53:57'),(4,'510a959c-410a-4ae2-943d-576f9233329e','4ea3d921-a03a-4ac7-b67e-3862ef0eef80','2025-06-02 16:00:23',NULL,'2025-06-01 16:00:23'),(5,'510a959c-410a-4ae2-943d-576f9233329e','163be081-e847-4ce9-8b6a-5acd92d5811d','2025-06-02 16:01:22',NULL,'2025-06-01 16:01:22'),(6,'510a959c-410a-4ae2-943d-576f9233329e','e06d0718-596e-4365-9d9c-fd6a1ee1e812','2025-06-02 16:15:52','2025-06-01 16:17:35','2025-06-01 16:15:52'),(7,'9214bd45-a7b8-430d-ae78-2d82c8585730','a52adfbe-2705-4222-9ec7-f065e4d4acb4','2025-06-04 11:45:02',NULL,'2025-06-03 11:45:02'),(8,'54c8ab8d-6e45-4ef0-a537-2a3ca6e79625','96a69080-66ac-4261-8981-3108c885e741','2025-06-04 12:35:06','2025-06-03 12:35:26','2025-06-03 12:35:06'),(9,'eec65d29-dac1-4d61-9cf5-80b1813fd102','947d7429-6b14-41d7-ab68-554b851f8e5f','2025-08-17 17:10:10',NULL,'2025-08-16 17:10:10'),(10,'4e389ead-4a91-4842-980c-74bfc30448eb','211a9c0f-7404-4ed9-a0a4-56b98319ca4b','2025-08-18 06:14:35',NULL,'2025-08-17 06:14:35'),(11,'02b64b25-f3d5-4477-9dfa-e8f20ea7a595','6ccb7ab0-b7d3-4214-aa31-37487924a611','2025-08-18 06:18:17',NULL,'2025-08-17 06:18:17'),(12,'86c44ad2-9a42-403c-af7f-c7146afde42a','24f98a88-b51a-4b63-b6be-af313d5660f4','2025-08-18 06:21:05',NULL,'2025-08-17 06:21:05'),(13,'8218d2fe-e7fb-4e04-8aab-b7af3630e184','8e4ed25f-9424-41ba-8900-061489e2ac07','2025-08-18 06:22:22',NULL,'2025-08-17 06:22:22'),(14,'43b75ba8-8c7f-40e9-ae44-cd12aa3db57b','76ba5fdc-a7a4-4f48-b748-4068f22c2f1e','2025-08-18 06:25:17',NULL,'2025-08-17 06:25:17');
/*!40000 ALTER TABLE `email_verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `inventory_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `variant_id` int DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `reserved_quantity` int NOT NULL DEFAULT '0',
  `min_stock_level` int DEFAULT '10',
  `max_stock_level` int DEFAULT '1000',
  `location` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'main_warehouse',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  UNIQUE KEY `unique_inventory` (`product_id`,`variant_id`,`location`),
  KEY `variant_id` (`variant_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_quantity` (`quantity`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (2,2,NULL,75,0,15,1000,'main_warehouse','2025-06-01 11:11:33'),(4,4,NULL,192,8,30,1000,'main_warehouse','2025-06-02 11:50:03'),(5,5,NULL,150,0,25,1000,'main_warehouse','2025-06-01 11:11:33'),(7,7,NULL,120,0,20,1000,'main_warehouse','2025-06-01 11:11:33'),(8,8,NULL,60,0,10,1000,'main_warehouse','2025-06-01 11:11:33'),(9,9,NULL,180,0,35,1000,'main_warehouse','2025-06-01 11:11:33'),(10,10,NULL,220,0,40,1000,'main_warehouse','2025-06-01 11:11:33'),(12,1,NULL,150,0,20,500,'main_warehouse','2025-08-16 11:25:19');
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int DEFAULT NULL,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variant_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`),
  KEY `variant_id` (`variant_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_order_items_product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (3,'ec612112-a2e5-4c8a-94b5-0e803da660b9',1,NULL,'Premium Almonds',NULL,6,799.00,4794.00,'2025-06-01 14:53:55'),(4,'ec612112-a2e5-4c8a-94b5-0e803da660b9',4,NULL,'Chia Seeds',NULL,3,249.00,747.00,'2025-06-01 14:53:55'),(5,'ec612112-a2e5-4c8a-94b5-0e803da660b9',6,NULL,'Arabica Coffee Beans',NULL,3,549.00,1647.00,'2025-06-01 14:53:55'),(6,'867ac36e-58ed-436b-af33-1975b8c92aee',1,NULL,'Premium Almonds',NULL,2,799.00,1598.00,'2025-06-01 14:54:07'),(7,'867ac36e-58ed-436b-af33-1975b8c92aee',4,NULL,'Chia Seeds',NULL,1,249.00,249.00,'2025-06-01 14:54:07'),(8,'867ac36e-58ed-436b-af33-1975b8c92aee',6,NULL,'Arabica Coffee Beans',NULL,1,549.00,549.00,'2025-06-01 14:54:07'),(9,'3a8221c8-4ff1-4dcf-87b1-c184993c2dc8',1,NULL,'Premium Almonds',NULL,2,799.00,1598.00,'2025-06-01 16:21:50'),(10,'3a8221c8-4ff1-4dcf-87b1-c184993c2dc8',4,NULL,'Chia Seeds',NULL,1,249.00,249.00,'2025-06-01 16:21:50'),(11,'3a8221c8-4ff1-4dcf-87b1-c184993c2dc8',6,NULL,'Arabica Coffee Beans',NULL,1,549.00,549.00,'2025-06-01 16:21:50'),(12,'9c72cdce-4571-4ef3-8e89-7b43c506e3b9',1,NULL,'Premium Almonds',NULL,2,799.00,1598.00,'2025-06-01 16:22:07'),(13,'9c72cdce-4571-4ef3-8e89-7b43c506e3b9',4,NULL,'Chia Seeds',NULL,1,249.00,249.00,'2025-06-01 16:22:07'),(14,'9c72cdce-4571-4ef3-8e89-7b43c506e3b9',6,NULL,'Arabica Coffee Beans',NULL,1,549.00,549.00,'2025-06-01 16:22:07'),(15,'4fca4ae3-d628-4809-87d0-825bf83df0dd',1,NULL,'Premium Almonds',NULL,2,799.00,1598.00,'2025-06-02 11:49:46'),(16,'4fca4ae3-d628-4809-87d0-825bf83df0dd',4,NULL,'Chia Seeds',NULL,1,249.00,249.00,'2025-06-02 11:49:46'),(17,'4fca4ae3-d628-4809-87d0-825bf83df0dd',6,NULL,'Arabica Coffee Beans',NULL,1,549.00,549.00,'2025-06-02 11:49:46'),(18,'4923f840-4fce-4b47-aaa7-a7cfe828c600',1,NULL,'Premium Almonds',NULL,2,799.00,1598.00,'2025-06-02 11:50:03'),(19,'4923f840-4fce-4b47-aaa7-a7cfe828c600',4,NULL,'Chia Seeds',NULL,1,249.00,249.00,'2025-06-02 11:50:03'),(20,'4923f840-4fce-4b47-aaa7-a7cfe828c600',6,NULL,'Arabica Coffee Beans',NULL,1,549.00,549.00,'2025-06-02 11:50:03');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_tracking`
--

DROP TABLE IF EXISTS `order_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_tracking` (
  `tracking_id` int NOT NULL AUTO_INCREMENT,
  `order_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('order_placed','confirmed','processing','packed','shipped','out_for_delivery','delivered','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tracking_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `order_tracking_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_tracking`
--

LOCK TABLES `order_tracking` WRITE;
/*!40000 ALTER TABLE `order_tracking` DISABLE KEYS */;
INSERT INTO `order_tracking` VALUES (1,'ec612112-a2e5-4c8a-94b5-0e803da660b9','order_placed','COD order confirmed',NULL,'2025-06-01 14:53:55'),(2,'867ac36e-58ed-436b-af33-1975b8c92aee','order_placed','Payment completed. Order confirmed.',NULL,'2025-06-01 14:54:07'),(3,'3a8221c8-4ff1-4dcf-87b1-c184993c2dc8','order_placed','COD order confirmed',NULL,'2025-06-01 16:21:50'),(4,'9c72cdce-4571-4ef3-8e89-7b43c506e3b9','order_placed','Payment completed. Order confirmed.',NULL,'2025-06-01 16:22:07'),(5,'4fca4ae3-d628-4809-87d0-825bf83df0dd','order_placed','COD order confirmed',NULL,'2025-06-02 11:49:46'),(6,'4923f840-4fce-4b47-aaa7-a7cfe828c600','order_placed','Payment completed. Order confirmed.',NULL,'2025-06-02 11:50:03'),(7,'4fca4ae3-d628-4809-87d0-825bf83df0dd','shipped','Order shipped via courier partner',NULL,'2025-06-02 11:50:23');
/*!40000 ALTER TABLE `order_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','confirmed','processing','shipped','delivered','cancelled','refunded') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `subtotal` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `cgst_amount` decimal(10,2) DEFAULT '0.00',
  `sgst_amount` decimal(10,2) DEFAULT '0.00',
  `igst_amount` decimal(10,2) DEFAULT '0.00',
  `tax_rate` decimal(5,2) DEFAULT '0.00',
  `shipping_amount` decimal(10,2) DEFAULT '0.00',
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` enum('cod','online','wallet') COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_status` enum('pending','completed','failed','refunded') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `shipping_address` json NOT NULL,
  `billing_address` json DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_order_number` (`order_number`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_orders_total_amount` (`total_amount`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('3a8221c8-4ff1-4dcf-87b1-c184993c2dc8','510a959c-410a-4ae2-943d-576f9233329e','ORD202506015560','confirmed',2396.00,119.80,0.00,0.00,119.80,5.00,0.00,200.00,2315.80,'cod','pending','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Please call before delivery','2025-06-01 16:21:50','2025-06-01 16:21:50'),('4923f840-4fce-4b47-aaa7-a7cfe828c600','510a959c-410a-4ae2-943d-576f9233329e','ORD202506029272','confirmed',2396.00,119.80,0.00,0.00,119.80,5.00,0.00,0.00,2515.80,'wallet','completed','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Wallet payment test','2025-06-02 11:50:03','2025-06-02 11:50:03'),('4fca4ae3-d628-4809-87d0-825bf83df0dd','510a959c-410a-4ae2-943d-576f9233329e','ORD202506028417','shipped',2396.00,119.80,0.00,0.00,119.80,5.00,0.00,200.00,2315.80,'cod','pending','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Please call before delivery','2025-06-02 11:49:46','2025-06-02 11:50:23'),('68ee2ebe-ac2d-4ecd-9bba-ab2c5a3dab1d','510a959c-410a-4ae2-943d-576f9233329e','ORD202506018983','pending',2396.00,119.80,0.00,0.00,119.80,5.00,0.00,200.00,2315.80,'cod','pending','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Please call before delivery','2025-06-01 11:19:04','2025-06-01 11:19:03'),('69b115c4-dcd0-4f17-993e-566a039302ad','510a959c-410a-4ae2-943d-576f9233329e','ORD202506016764','pending',4792.00,239.60,0.00,0.00,239.60,5.00,0.00,200.00,4831.60,'cod','pending','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Please call before delivery','2025-06-01 14:46:02','2025-06-01 14:46:01'),('867ac36e-58ed-436b-af33-1975b8c92aee','510a959c-410a-4ae2-943d-576f9233329e','ORD202506011767','confirmed',2396.00,119.80,0.00,0.00,119.80,5.00,0.00,0.00,2515.80,'wallet','completed','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Wallet payment test','2025-06-01 14:54:07','2025-06-01 14:54:07'),('9c72cdce-4571-4ef3-8e89-7b43c506e3b9','510a959c-410a-4ae2-943d-576f9233329e','ORD202506018182','confirmed',2396.00,119.80,0.00,0.00,119.80,5.00,0.00,0.00,2515.80,'wallet','completed','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Wallet payment test','2025-06-01 16:22:07','2025-06-01 16:22:07'),('ec612112-a2e5-4c8a-94b5-0e803da660b9','510a959c-410a-4ae2-943d-576f9233329e','ORD202506013840','confirmed',7188.00,359.40,0.00,0.00,359.40,5.00,0.00,200.00,7347.40,'cod','pending','{\"city\": \"Mumbai\", \"phone\": \"9876543210\", \"state\": \"Maharashtra\", \"country\": \"India\", \"full_name\": \"Test User\", \"postal_code\": \"400001\", \"address_line1\": \"123 Test Street\", \"address_line2\": \"Near Test Mall\"}',NULL,'Please call before delivery','2025-06-01 14:53:55','2025-06-01 14:53:54');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `reset_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reset_id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_token` (`token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (1,'9214bd45-a7b8-430d-ae78-2d82c8585730','138439d1-65cf-4fbc-bcec-0ce1ac619395','2025-06-03 14:20:18',NULL,'2025-06-03 12:20:18'),(2,'510a959c-410a-4ae2-943d-576f9233329e','905907f2-c4f4-4fbd-8005-36b2be894dbf','2025-08-16 13:47:27','2025-08-16 11:51:39','2025-08-16 11:47:27'),(3,'test-forgot-pwd-user','0fe151ea-bb41-4a41-ad2b-75b068cc47ad','2025-08-16 13:52:32','2025-08-16 11:52:35','2025-08-16 11:52:32'),(4,'eec65d29-dac1-4d61-9cf5-80b1813fd102','648cb21a-5a42-413f-8a81-7dbc813faf0a','2025-08-16 19:10:20','2025-08-16 17:10:44','2025-08-16 17:10:20'),(5,'4054f2f5-021d-442a-a332-0e78c8027686','3d4b435a-35ea-42e5-8d59-2c1e53995d9d','2025-08-16 19:11:34','2025-08-16 17:12:13','2025-08-16 17:11:34');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `product_deletion_analysis`
--

DROP TABLE IF EXISTS `product_deletion_analysis`;
/*!50001 DROP VIEW IF EXISTS `product_deletion_analysis`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `product_deletion_analysis` AS SELECT 
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `status`,
 1 AS `order_count`,
 1 AS `review_count`,
 1 AS `cart_count`,
 1 AS `wishlist_count`,
 1 AS `deletion_recommendation`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int DEFAULT '0',
  `is_primary` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_is_primary` (`is_primary`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (2,2,'/static/uploads/products/cashews1.jpg','Roasted Cashews',0,1,'2025-06-01 11:11:33'),(4,4,'/static/uploads/products/chia1.jpg','Chia Seeds',0,1,'2025-06-01 11:11:33'),(5,5,'/static/uploads/products/flax1.jpg','Flax Seeds',0,1,'2025-06-01 11:11:33'),(7,7,'/static/uploads/products/tea1.jpg','Green Tea',0,1,'2025-06-01 11:11:33'),(8,8,'/static/uploads/products/honey1.jpg','Manuka Honey',0,1,'2025-06-01 11:11:33'),(9,9,'/static/uploads/products/jaggery1.jpg','Organic Jaggery',0,1,'2025-06-01 11:11:33'),(10,10,'/static/uploads/products/turmeric1.jpg','Turmeric Powder',0,1,'2025-06-01 11:11:33');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variants` (
  `variant_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `variant_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variant_value` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price_adjustment` decimal(10,2) DEFAULT '0.00',
  `weight_adjustment` decimal(8,3) DEFAULT '0.000',
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`variant_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `category_id` int NOT NULL,
  `brand` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `weight` decimal(8,3) DEFAULT NULL,
  `dimensions` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hsn_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT '0000',
  `gst_rate` decimal(5,2) DEFAULT '5.00',
  `tax_category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'standard',
  `is_featured` tinyint(1) DEFAULT '0',
  `meta_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive','draft') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`),
  KEY `idx_featured` (`is_featured`),
  KEY `idx_sku` (`sku`),
  KEY `idx_products_price` (`price`),
  KEY `idx_products_discount_price` (`discount_price`),
  FULLTEXT KEY `idx_search` (`product_name`,`description`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Updated Product 17:58:08',' premium almonds, rich in protein and healthy fats. ',1,'NutriPro','ALM001',999.99,799.00,NULL,NULL,NULL,'0801',5.00,'standard',1,NULL,NULL,'active','2025-06-01 11:11:33','2025-06-04 03:44:24'),(2,'Roasted Cashews','Premium roasted cashews .',1,'NutriPro','CSH001',1299.00,1199.00,NULL,NULL,NULL,'0801',5.00,'standard',1,NULL,NULL,'active','2025-06-01 11:11:33','2025-06-01 11:11:33'),(4,'Chia Seeds','Superfood chia seeds .',2,'HealthySeeds','CHI001',299.00,249.00,NULL,NULL,NULL,'1207',5.00,'standard',1,NULL,NULL,'active','2025-06-01 11:11:33','2025-06-01 11:11:33'),(5,'Flax Seeds','Organic flax seeds rich.',2,'HealthySeeds','FLX001',199.00,179.00,NULL,NULL,NULL,'1207',5.00,'standard',0,NULL,NULL,'active','2025-06-01 11:11:33','2025-06-01 11:11:33'),(6,'Arabica Coffee Beans','Premium Arabica coffee .',3,'CoffeeMaster','COF001',599.00,549.00,NULL,NULL,NULL,'0901',5.00,'standard',1,NULL,NULL,'inactive','2025-06-01 11:11:33','2025-06-04 04:36:12'),(7,'Green Tea','Premium green tea leaves with ',3,'TeaGarden','TEA001',399.00,349.00,NULL,NULL,NULL,'0902',5.00,'standard',0,NULL,NULL,'inactive','2025-06-01 11:11:33','2025-06-04 04:36:12'),(8,'Manuka Honey','Pure Manuka honey with.',4,'PureHoney','HON001',1299.00,1199.00,NULL,NULL,NULL,'0409',0.00,'standard',1,NULL,NULL,'active','2025-06-01 11:11:33','2025-06-01 11:11:33'),(9,'Organic Jaggery','Organic jaggery .',4,'OrganicSweet','JAG001',199.00,179.00,NULL,NULL,NULL,'1701',5.00,'standard',0,NULL,NULL,'active','2025-06-01 11:11:33','2025-06-01 11:11:33'),(10,'Turmeric Powder','Pure turmeric powder with high.',5,'SpiceMaster','TUR001',149.00,129.00,NULL,NULL,NULL,'0910',5.00,'standard',1,NULL,NULL,'inactive','2025-06-01 11:11:33','2025-06-04 04:36:53');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cleanup_cart_on_product_inactive` AFTER UPDATE ON `products` FOR EACH ROW BEGIN
    IF NEW.status = 'inactive' AND OLD.status = 'active' THEN
        DELETE FROM cart WHERE product_id = NEW.product_id;
        DELETE FROM wishlist WHERE product_id = NEW.product_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cleanup_cart_on_product_delete` BEFORE DELETE ON `products` FOR EACH ROW BEGIN
    DELETE FROM cart WHERE product_id = OLD.product_id;
    DELETE FROM wishlist WHERE product_id = OLD.product_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `promocodes`
--

DROP TABLE IF EXISTS `promocodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promocodes` (
  `code_id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount_type` enum('percentage','fixed') COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `min_order_amount` decimal(10,2) DEFAULT '0.00',
  `max_discount_amount` decimal(10,2) DEFAULT NULL,
  `usage_limit` int DEFAULT NULL,
  `used_count` int DEFAULT '0',
  `user_limit` int DEFAULT '1',
  `valid_from` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `valid_until` timestamp NOT NULL,
  `status` enum('active','inactive','expired') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`code_id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_code` (`code`),
  KEY `idx_status` (`status`),
  KEY `idx_valid_dates` (`valid_from`,`valid_until`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promocodes`
--

LOCK TABLES `promocodes` WRITE;
/*!40000 ALTER TABLE `promocodes` DISABLE KEYS */;
INSERT INTO `promocodes` VALUES (1,'WELCOME10','Welcome discount - 10% off on first order','percentage',10.00,500.00,200.00,1000,3,1,'2025-06-01 11:11:33','2025-12-01 11:11:33','active','2025-06-01 11:11:33'),(2,'SAVE50','Flat ₹50 off on orders above ₹300','fixed',50.00,300.00,50.00,500,0,1,'2025-06-01 11:11:33','2025-09-01 11:11:33','active','2025-06-01 11:11:33'),(3,'NUTS20','20% off on all nuts products','percentage',20.00,200.00,500.00,200,0,1,'2025-06-01 11:11:33','2025-07-01 11:11:33','active','2025-06-01 11:11:33'),(4,'FREESHIP','Free shipping on all orders','fixed',50.00,0.00,50.00,NULL,0,1,'2025-06-01 11:11:33','2026-06-01 11:11:33','active','2025-06-01 11:11:33'),(5,'BULK15','15% off on orders above ₹1000','percentage',15.00,1000.00,1000.00,100,0,1,'2025-06-01 11:11:33','2025-08-01 11:11:33','active','2025-06-01 11:11:33');
/*!40000 ALTER TABLE `promocodes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referral_codes`
--

DROP TABLE IF EXISTS `referral_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referral_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referral_codes`
--

LOCK TABLES `referral_codes` WRITE;
/*!40000 ALTER TABLE `referral_codes` DISABLE KEYS */;
INSERT INTO `referral_codes` VALUES (1,'4e389ead-4a91-4842-980c-74bfc30448eb','REF0RW8GP','active','2025-08-17 11:44:35'),(2,'02b64b25-f3d5-4477-9dfa-e8f20ea7a595','REF92X0XH','active','2025-08-17 11:48:17'),(3,'86c44ad2-9a42-403c-af7f-c7146afde42a','REFB3Z1X7','active','2025-08-17 11:51:05'),(4,'8218d2fe-e7fb-4e04-8aab-b7af3630e184','REFGI7GO5','active','2025-08-17 11:52:22'),(5,'43b75ba8-8c7f-40e9-ae44-cd12aa3db57b','REF1H3FG8','active','2025-08-17 11:55:17');
/*!40000 ALTER TABLE `referral_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `referral_uses`
--

DROP TABLE IF EXISTS `referral_uses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `referral_uses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `referral_code_id` int NOT NULL,
  `referred_user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reward_given` tinyint(1) DEFAULT '0',
  `first_purchase_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `referral_code_id` (`referral_code_id`),
  KEY `idx_referred_user` (`referred_user_id`),
  CONSTRAINT `referral_uses_ibfk_1` FOREIGN KEY (`referral_code_id`) REFERENCES `referral_codes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `referral_uses`
--

LOCK TABLES `referral_uses` WRITE;
/*!40000 ALTER TABLE `referral_uses` DISABLE KEYS */;
/*!40000 ALTER TABLE `referral_uses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `status` enum('pending','approved','rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `helpful_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `unique_user_product_review` (`user_id`,`product_id`),
  KEY `order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_rating` (`rating`),
  KEY `idx_reviews_created_at` (`created_at`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE SET NULL,
  CONSTRAINT `reviews_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referral_code` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referred_by` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profile_image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified` tinyint(1) DEFAULT '0',
  `phone_verified` tinyint(1) DEFAULT '0',
  `status` enum('active','inactive','suspended') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `verification_sent_at` timestamp NULL DEFAULT NULL,
  `password_reset_requested_at` timestamp NULL DEFAULT NULL,
  `password_reset_count` int DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `referral_code` (`referral_code`),
  KEY `idx_email` (`email`),
  KEY `idx_phone` (`phone`),
  KEY `idx_status` (`status`),
  KEY `idx_referral_code` (`referral_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('02b64b25-f3d5-4477-9dfa-e8f20ea7a595','frontendtest@gmail.com','scrypt:32768:8:1$ieQ7BZEz3O77Hbcv$7882a00ae2df01755164fc650ee1263e7aa107135ed8cd214115dcf918b903c72ec4417f764929df0cc8abf399e0c423db8c8ae2262c2bfe58050f395f634136','Frontend','Test','9876543210',NULL,NULL,NULL,NULL,NULL,0,0,'active','2025-08-17 06:18:17','2025-08-17 06:18:17',NULL,NULL,0),('4054f2f5-021d-442a-a332-0e78c8027686','sanidhyarana1@gmail.com','scrypt:32768:8:1$YdHPQCNiQZb4wd8Z$d08ac69261126cf3d2cddc6c72f61b89ceb9bc61da6d62348c74d21efd9ae5a2ef9f93cdcab719b2f7f1cf5918b90e668e24a0dc07c7e1084db546b3f171df4d','sanidhya','rana','6261116108','REF7ABA7ADE',NULL,NULL,NULL,NULL,1,0,'active','2025-06-01 15:53:53','2025-08-16 17:12:13',NULL,NULL,0),('43b75ba8-8c7f-40e9-ae44-cd12aa3db57b','browsertest@gmail.com','scrypt:32768:8:1$mJ1VfLoDFevXM4XX$fccb94ed3c06893fe76dcba5f8cb8b35cb0378882546e4b7fde9824ed55067af2f6d4c442b01a7c4018ec2520fa147283d12ad4b299b697dc714038e385d289c','Browser','Test','9876543210',NULL,NULL,NULL,NULL,NULL,0,0,'active','2025-08-17 06:25:17','2025-08-17 06:25:17',NULL,NULL,0),('48db8ede-14e8-4ca4-90ab-1fccea8ca9fa','directtest@gmail.com','scrypt:32768:8:1$oD5eBN0ARqehU2gg$02caae35132c9c6da7e420ad86fdf2f90bce996efa67b018a8bd123fd4c84fac467c5534ec914ba3fe8a5f23ccfa256f20d4186d3cb9d35142775b9184f369e0','Direct','Test','9876543210',NULL,NULL,NULL,NULL,NULL,0,0,'active','2025-08-17 06:13:53','2025-08-17 06:13:53',NULL,NULL,0),('4e389ead-4a91-4842-980c-74bfc30448eb','webtest@gmail.com','scrypt:32768:8:1$7bKQZwVPFksYJjoF$8e126fd890818f133de472a5c33ce56ab2d5a501682ae21d8454657014e6413baa802b5ee060faa7bc0c23e7beaa20a043d918d246a5ada5155e9f81c104ea80','Web','Test','9876543210',NULL,NULL,NULL,NULL,NULL,0,0,'active','2025-08-17 06:14:35','2025-08-17 06:14:35',NULL,NULL,0),('510a959c-410a-4ae2-943d-576f9233329e','testuser@example.com','scrypt:32768:8:1$mMAulNTAukWEB8N7$905ce2e86218d46a0443ddb770ac6fd0ba4e4115846b6ac84aa86f7dd434f6089eb63e86979df70ee6c7e776a52f2ad576550c9af7916f1e5b4a101d26735ee0','Test','User','9876543210','REF2B8DDADB',NULL,NULL,NULL,NULL,1,0,'active','2025-06-01 11:16:42','2025-08-16 16:42:06','2025-06-01 16:15:56',NULL,0),('54c8ab8d-6e45-4ef0-a537-2a3ca6e79625','laxtsan6@gmail.com','scrypt:32768:8:1$3EHKDKDqoTG7uIpn$62cc99654f93a20508cb4fa29530baf65f5bf82ac441827b0f47b632fc38da77462fe6077f1ef7d57f06bf031f5660cff998b09419979b9a4171e7055c48fc5c','sann','r','62611116109','REF2B16EE21',NULL,NULL,NULL,NULL,1,0,'active','2025-06-03 12:35:05','2025-08-16 16:42:06','2025-06-03 12:35:10',NULL,0),('8218d2fe-e7fb-4e04-8aab-b7af3630e184','frontendtest123@gmail.com','scrypt:32768:8:1$IrJaivCWEzsd1D2D$78c6fec242417d16a51c7c0d2dfac3b54e0158eca7657102b7a729fe4f50cd80e712a63422fd4c2de6765b597bb342c5e5b51f0fc97f34186ce9ac1592d93615','Frontend','Test123','9876543210',NULL,NULL,NULL,NULL,NULL,0,0,'active','2025-08-17 06:22:22','2025-08-17 06:22:22',NULL,NULL,0),('86c44ad2-9a42-403c-af7f-c7146afde42a','corstest2@gmail.com','scrypt:32768:8:1$Av3sTYiGKIU0DJCm$76f84124507f68a0dbb2734dfb560669555569377aafc06abad63499554e9a58fd73ede6247c05efe903af68adf39e1a88e9ad33bd1b937644108df993226a10','CORS','Test','9876543210',NULL,NULL,NULL,NULL,NULL,0,0,'active','2025-08-17 06:21:05','2025-08-17 06:21:05',NULL,NULL,0),('9214bd45-a7b8-430d-ae78-2d82c8585730','sanidhyarana5@gmail.com','scrypt:32768:8:1$R9pfKKgolH6W5dM2$16d7c85b47203016ca1dc6ec1f7a55268c36ba8aef2222c5405c45442b60a7750ce54c89a3d9cc9a994b163dc8cddc5e58255dfd1d9811aeacc29f3d20e497aa','sanidhya','rana','07898353410','REF56B19370',NULL,NULL,NULL,NULL,0,0,'active','2025-06-03 11:45:02','2025-08-16 16:42:06','2025-06-03 11:45:08','2025-06-03 12:20:23',1),('eec65d29-dac1-4d61-9cf5-80b1813fd102','test.reset@example.com','scrypt:32768:8:1$GXlNylkJFNbKoiCf$fec6ae31db43c9d00d27dde7a821dbc6c9c33cec46a931606501736aa86eacb05fdad7fab872f14ee2a80c12040be7a4156c60d876b941b9bde328b6bd614cd1','Test','User','1234567890',NULL,NULL,NULL,NULL,NULL,0,0,'active','2025-08-16 17:10:10','2025-08-16 17:10:44',NULL,NULL,0),('test-forgot-pwd-user','testforgot@example.com','scrypt:32768:8:1$CFAnvEbgtcXrni0U$f856f1699e60c1aaee565236385d5e04f3a1032423acf43dfe53ff1f7dab1eb97f47af05b50966ee4e36dc7d55e6e83934e4e27ceb1cd4346b992bd3b2de1e0b','Test','ForgotPwd','1234567890','REF326B65D2',NULL,NULL,NULL,NULL,0,0,'active','2025-08-16 11:52:32','2025-08-16 16:42:06',NULL,NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallet`
--

DROP TABLE IF EXISTS `wallet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallet` (
  `wallet_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `balance` decimal(10,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`wallet_id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `wallet_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet`
--

LOCK TABLES `wallet` WRITE;
/*!40000 ALTER TABLE `wallet` DISABLE KEYS */;
INSERT INTO `wallet` VALUES (1,'510a959c-410a-4ae2-943d-576f9233329e',2452.60,'2025-06-01 11:18:47','2025-06-02 11:50:03');
/*!40000 ALTER TABLE `wallet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallet_transactions`
--

DROP TABLE IF EXISTS `wallet_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallet_transactions` (
  `transaction_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_type` enum('credit','debit') COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `balance_after` decimal(10,2) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_type` enum('order','refund','cashback','referral','admin_adjustment') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','completed','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'completed',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_transaction_type` (`transaction_type`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_wallet_transactions_created_at` (`created_at`),
  CONSTRAINT `wallet_transactions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallet_transactions`
--

LOCK TABLES `wallet_transactions` WRITE;
/*!40000 ALTER TABLE `wallet_transactions` DISABLE KEYS */;
INSERT INTO `wallet_transactions` VALUES ('19eb8780-5a75-4e12-a2ac-71505641cd8b','510a959c-410a-4ae2-943d-576f9233329e','debit',2515.80,3484.20,'Payment for order','order',NULL,'completed','2025-06-01 14:54:07'),('2c91abcc-25b0-4758-b0b6-4b92c9e0d84c','510a959c-410a-4ae2-943d-576f9233329e','debit',2515.80,2968.40,'Payment for order','order',NULL,'completed','2025-06-01 16:22:07'),('3bb495d4-9ab5-4ba4-a17b-67533e085d95','510a959c-410a-4ae2-943d-576f9233329e','credit',2000.00,4968.40,'Money added to wallet',NULL,NULL,'completed','2025-06-02 11:49:29'),('50eec67a-9ebf-49d9-9d91-a55d2613d74f','510a959c-410a-4ae2-943d-576f9233329e','credit',2000.00,4000.00,'Money added to wallet',NULL,NULL,'completed','2025-06-01 14:45:45'),('7eb80b10-8397-4f80-b128-5a61455dee9a','510a959c-410a-4ae2-943d-576f9233329e','credit',2000.00,5484.20,'Money added to wallet',NULL,NULL,'completed','2025-06-01 16:21:34'),('c196b660-905a-44af-96ed-7c1f048eafbb','510a959c-410a-4ae2-943d-576f9233329e','credit',2000.00,6000.00,'Money added to wallet',NULL,NULL,'completed','2025-06-01 14:53:38'),('d5708107-d883-49cf-b1f8-7aaeda37ac3c','510a959c-410a-4ae2-943d-576f9233329e','debit',2515.80,2452.60,'Payment for order','order',NULL,'completed','2025-06-02 11:50:03'),('d61c6b6e-fe7b-4d4d-8bc4-c80446352a20','510a959c-410a-4ae2-943d-576f9233329e','credit',2000.00,2000.00,'Money added to wallet',NULL,NULL,'completed','2025-06-01 11:18:47');
/*!40000 ALTER TABLE `wallet_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `wishlist_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`wishlist_id`),
  UNIQUE KEY `unique_wishlist_item` (`user_id`,`product_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_wishlist_product_id` (`product_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ecommerce_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `cleanup_product_references` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cleanup_product_references`(IN p_product_id INT)
BEGIN
    -- Remove from all user carts
    DELETE FROM cart WHERE product_id = p_product_id;
    
    -- Remove from all wishlists
    DELETE FROM wishlist WHERE product_id = p_product_id;
    
    -- Log the cleanup
    INSERT INTO admin_logs (action, entity_type, entity_id, details, created_at)
    VALUES ('cleanup', 'product', p_product_id, 'Cleaned cart and wishlist references', NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `ecommerce_db`
--

USE `ecommerce_db`;

--
-- Final view structure for view `product_deletion_analysis`
--

/*!50001 DROP VIEW IF EXISTS `product_deletion_analysis`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `product_deletion_analysis` AS select `p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,`p`.`status` AS `status`,count(distinct `oi`.`order_id`) AS `order_count`,count(distinct `r`.`review_id`) AS `review_count`,count(distinct `c`.`cart_id`) AS `cart_count`,count(distinct `w`.`wishlist_id`) AS `wishlist_count`,(case when ((count(distinct `oi`.`order_id`) > 0) or (count(distinct `r`.`review_id`) > 0)) then 'soft_delete_required' else 'can_hard_delete' end) AS `deletion_recommendation` from ((((`products` `p` left join `order_items` `oi` on((`p`.`product_id` = `oi`.`product_id`))) left join `reviews` `r` on((`p`.`product_id` = `r`.`product_id`))) left join `cart` `c` on((`p`.`product_id` = `c`.`product_id`))) left join `wishlist` `w` on((`p`.`product_id` = `w`.`product_id`))) group by `p`.`product_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-21 17:35:38
