/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: licensing
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `jurisdiction`
--

DROP TABLE IF EXISTS `jurisdiction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jurisdiction` (
  `state_code` char(2) NOT NULL,
  `state_name` varchar(40) NOT NULL,
  `requires_license` tinyint(1) NOT NULL DEFAULT 1,
  `renewal_months` tinyint(4) NOT NULL,
  `ce_hours` tinyint(4) NOT NULL,
  PRIMARY KEY (`state_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `license`
--

DROP TABLE IF EXISTS `license`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `license` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `producer_id` int(11) NOT NULL,
  `state_code` char(2) NOT NULL,
  `license_number` varchar(20) NOT NULL,
  `line_of_authority` varchar(40) NOT NULL,
  `effective_date` date NOT NULL,
  `expiration_date` date NOT NULL,
  `status` enum('active','expired','pending','revoked') NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_prod_state_loa` (`producer_id`,`state_code`,`line_of_authority`),
  KEY `state_code` (`state_code`),
  CONSTRAINT `license_ibfk_1` FOREIGN KEY (`producer_id`) REFERENCES `producer` (`id`),
  CONSTRAINT `license_ibfk_2` FOREIGN KEY (`state_code`) REFERENCES `jurisdiction` (`state_code`)
) ENGINE=InnoDB AUTO_INCREMENT=416 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `producer`
--

DROP TABLE IF EXISTS `producer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `producer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(80) NOT NULL,
  `npn` varchar(12) NOT NULL,
  `hire_date` date NOT NULL,
  `status` enum('active','inactive','terminated') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_npn` (`npn`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-30  9:59:28
/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: licensing
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Dumping data for table `jurisdiction`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `jurisdiction` WRITE;
/*!40000 ALTER TABLE `jurisdiction` DISABLE KEYS */;
INSERT INTO `jurisdiction` VALUES
('AK','Alaska',1,24,24),
('AL','Alabama',1,24,24),
('AR','Arkansas',1,24,24),
('AZ','Arizona',1,24,0),
('CA','California',1,24,24),
('CO','Colorado',0,24,0),
('CT','Connecticut',1,24,0),
('DC','District of Columbia',0,24,0),
('DE','Delaware',1,24,12),
('FL','Florida',1,24,24),
('GA','Georgia',1,24,24),
('HI','Hawaii',1,24,0),
('IA','Iowa',1,24,24),
('ID','Idaho',1,24,24),
('IL','Illinois',0,24,0),
('IN','Indiana',1,24,24),
('KS','Kansas',0,24,0),
('KY','Kentucky',1,24,24),
('LA','Louisiana',1,24,24),
('MA','Massachusetts',0,24,0),
('MD','Maryland',0,24,0),
('ME','Maine',1,24,0),
('MI','Michigan',1,24,0),
('MN','Minnesota',1,24,24),
('MO','Missouri',0,24,0),
('MS','Mississippi',1,24,24),
('MT','Montana',1,24,24),
('NC','North Carolina',1,24,24),
('ND','North Dakota',0,24,0),
('NE','Nebraska',0,24,0),
('NH','New Hampshire',1,24,24),
('NJ','New Jersey',0,24,0),
('NM','New Mexico',1,24,24),
('NV','Nevada',1,24,24),
('NY','New York',1,24,0),
('OH','Ohio',0,24,0),
('OK','Oklahoma',1,24,24),
('OR','Oregon',1,24,24),
('PA','Pennsylvania',0,24,0),
('RI','Rhode Island',1,24,24),
('SC','South Carolina',1,24,0),
('SD','South Dakota',0,24,0),
('TN','Tennessee',0,24,0),
('TX','Texas',1,24,24),
('UT','Utah',1,24,24),
('VA','Virginia',0,24,0),
('VT','Vermont',1,24,0),
('WA','Washington',1,24,24),
('WI','Wisconsin',0,24,0),
('WV','West Virginia',1,24,24),
('WY','Wyoming',1,24,24);
/*!40000 ALTER TABLE `jurisdiction` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-30 10:00:58
