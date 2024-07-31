-- MySQL dump 10.13  Distrib 8.0.36-28, for Linux (x86_64)
--
-- Host: localhost    Database: userdata
-- ------------------------------------------------------
-- Server version	8.0.36-28.1

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
/*!50717 SELECT COUNT(*) INTO @rocksdb_has_p_s_session_variables FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'performance_schema' AND TABLE_NAME = 'session_variables' */;
/*!50717 SET @rocksdb_get_is_supported = IF (@rocksdb_has_p_s_session_variables, 'SELECT COUNT(*) INTO @rocksdb_is_supported FROM performance_schema.session_variables WHERE VARIABLE_NAME=\'rocksdb_bulk_load\'', 'SELECT 0') */;
/*!50717 PREPARE s FROM @rocksdb_get_is_supported */;
/*!50717 EXECUTE s */;
/*!50717 DEALLOCATE PREPARE s */;
/*!50717 SET @rocksdb_enable_bulk_load = IF (@rocksdb_is_supported, 'SET SESSION rocksdb_bulk_load = 1', 'SET @rocksdb_dummy_bulk_load = 0') */;
/*!50717 PREPARE s FROM @rocksdb_enable_bulk_load */;
/*!50717 EXECUTE s */;
/*!50717 DEALLOCATE PREPARE s */;

--
-- Table structure for table `pastedata`
--

DROP TABLE IF EXISTS `pastedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pastedata` (
  `dataid` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `userid` mediumint unsigned NOT NULL,
  `addtime` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `data` longblob NOT NULL,
  PRIMARY KEY (`dataid`),
  KEY `userindex` (`userid`),
  CONSTRAINT `user_constraint_two` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pastedata`
--

/*!40000 ALTER TABLE `pastedata` DISABLE KEYS */;
INSERT INTO `pastedata` VALUES (5,1,'2024-07-27 09:38:11',_binary 'SGVsbG8sIHBlcmNvbmEgY2x1c3Rlcgo='),(8,1,'2024-07-27 09:39:11',_binary 'VXNlcnMgbWVzc2FnZQo='),(11,1,'2024-07-27 13:35:13',''),(14,1,'2024-07-27 13:36:29',''),(15,1,'2024-07-27 13:36:48',''),(16,1,'2024-07-27 13:39:49',''),(18,1,'2024-07-27 13:45:29',_binary 'LWwK'),(20,1,'2024-07-27 13:53:41',''),(21,1,'2024-07-27 13:57:14',''),(22,1,'2024-07-27 14:00:19',''),(24,1,'2024-07-27 14:00:50',''),(27,1,'2024-07-27 14:07:32',''),(29,1,'2024-07-27 14:08:40',''),(30,1,'2024-07-27 14:09:20',''),(32,1,'2024-07-27 14:10:59',''),(34,1,'2024-07-27 14:13:50',''),(36,1,'2024-07-27 14:16:28',''),(38,1,'2024-07-27 14:16:46',''),(40,1,'2024-07-27 14:18:49',''),(43,1,'2024-07-27 16:48:35',''),(44,1,'2024-07-27 16:49:52',''),(45,1,'2024-07-27 16:52:58',''),(48,1,'2024-07-27 16:58:39',''),(50,1,'2024-07-27 17:21:50',''),(53,1,'2024-07-27 17:27:19',_binary 'SGVsbG8lMkMgd2ViIGZyb20K'),(55,1,'2024-07-27 17:28:25',_binary 'bGFiYSBjb21wbGV0ZQo='),(56,1,'2024-07-27 17:41:29',_binary 'Y29ycmVjdGlvbgo=');
/*!40000 ALTER TABLE `pastedata` ENABLE KEYS */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userid` mediumint unsigned NOT NULL AUTO_INCREMENT,
  `addtime` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `username` text NOT NULL,
  `password_sha512` binary(64) DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'2024-07-27 09:30:39','guru',_binary '±	\Ûªº$N∏$Aë~\–maãê\›	≥æ˝^9LpjãπÄ±\◊x^Yv\ÏõF\ﬂ_&ØZ.¶\—˝\…SÖˇ´¨ºÜ');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

--
-- Table structure for table `userdetail`
--

DROP TABLE IF EXISTS `userdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userdetail` (
  `userid` mediumint unsigned NOT NULL,
  `changetime` datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
  `fullname` text,
  `lastname` text,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(31) DEFAULT NULL,
  `address` text,
  `birthdate` datetime DEFAULT NULL,
  PRIMARY KEY (`userid`),
  CONSTRAINT `user_constraint` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userdetail`
--

/*!40000 ALTER TABLE `userdetail` DISABLE KEYS */;
INSERT INTO `userdetail` VALUES (1,'2024-07-27 09:30:54','Guru Von Workenstein',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `userdetail` ENABLE KEYS */;
/*!50112 SET @disable_bulk_load = IF (@is_rocksdb_supported, 'SET SESSION rocksdb_bulk_load = @old_rocksdb_bulk_load', 'SET @dummy_rocksdb_bulk_load = 0') */;
/*!50112 PREPARE s FROM @disable_bulk_load */;
/*!50112 EXECUTE s */;
/*!50112 DEALLOCATE PREPARE s */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-27 17:45:54
