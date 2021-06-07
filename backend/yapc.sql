/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 80025
Source Host           : localhost:3306
Source Database       : yapc

Target Server Type    : MYSQL
Target Server Version : 80025
File Encoding         : 65001

Date: 2021-06-07 14:12:57
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for author
-- ----------------------------
DROP TABLE IF EXISTS `author`;
CREATE TABLE `author` (
  `authorId` int NOT NULL AUTO_INCREMENT,
  `authorName` varchar(255) NOT NULL,
  `inst` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`authorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for benchmark
-- ----------------------------
DROP TABLE IF EXISTS `benchmark`;
CREATE TABLE `benchmark` (
  `benchId` int NOT NULL AUTO_INCREMENT,
  `metric` varchar(255) NOT NULL,
  `condition` varchar(255) DEFAULT NULL,
  `datasetId` int NOT NULL,
  `taskId` int NOT NULL,
  PRIMARY KEY (`benchId`),
  KEY `datasetOfBench` (`datasetId`),
  KEY `taskOfBench` (`taskId`),
  CONSTRAINT `datasetOfBench` FOREIGN KEY (`datasetId`) REFERENCES `dataset` (`datasetId`),
  CONSTRAINT `taskOfBench` FOREIGN KEY (`taskId`) REFERENCES `task` (`taskId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for code
-- ----------------------------
DROP TABLE IF EXISTS `code`;
CREATE TABLE `code` (
  `codeId` int NOT NULL AUTO_INCREMENT,
  `paperId` int NOT NULL,
  `codeLink` varchar(255) NOT NULL,
  `stars` int NOT NULL,
  `framework` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`codeId`),
  KEY `codeOfPaper` (`paperId`),
  CONSTRAINT `codeOfPaper` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for dataset
-- ----------------------------
DROP TABLE IF EXISTS `dataset`;
CREATE TABLE `dataset` (
  `datasetId` int NOT NULL AUTO_INCREMENT,
  `datasetDesc` varchar(255) DEFAULT NULL,
  `datasetLink` varchar(255) NOT NULL,
  `createDate` date NOT NULL,
  PRIMARY KEY (`datasetId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for method
-- ----------------------------
DROP TABLE IF EXISTS `method`;
CREATE TABLE `method` (
  `methodId` int NOT NULL AUTO_INCREMENT,
  `methodName` varchar(255) NOT NULL,
  `methodDesc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`methodId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for paper
-- ----------------------------
DROP TABLE IF EXISTS `paper`;
CREATE TABLE `paper` (
  `paperId` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `paperLink` varchar(255) NOT NULL,
  `abstLink` varchar(255) NOT NULL,
  `publishDate` date NOT NULL,
  PRIMARY KEY (`paperId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for paperauthor
-- ----------------------------
DROP TABLE IF EXISTS `paperauthor`;
CREATE TABLE `paperauthor` (
  `paperId` int NOT NULL,
  `authorId` int NOT NULL,
  `order` int NOT NULL,
  `iscorr` int NOT NULL,
  PRIMARY KEY (`paperId`,`authorId`),
  KEY `authorIdPaperAuthor` (`authorId`),
  CONSTRAINT `authorIdPaperAuthor` FOREIGN KEY (`authorId`) REFERENCES `author` (`authorId`) ON UPDATE RESTRICT,
  CONSTRAINT `paperIdPaperAuthor` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for paperbench
-- ----------------------------
DROP TABLE IF EXISTS `paperbench`;
CREATE TABLE `paperbench` (
  `paperId` int NOT NULL,
  `benchId` int NOT NULL,
  `score` decimal(3,3) NOT NULL,
  PRIMARY KEY (`paperId`,`benchId`),
  KEY `benchIdPaperBench` (`benchId`),
  CONSTRAINT `benchIdPaperBench` FOREIGN KEY (`benchId`) REFERENCES `benchmark` (`benchId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `paperIdPaperBench` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for papermethod
-- ----------------------------
DROP TABLE IF EXISTS `papermethod`;
CREATE TABLE `papermethod` (
  `paperId` int NOT NULL,
  `methodId` int NOT NULL,
  PRIMARY KEY (`paperId`,`methodId`),
  KEY `methodIdPaperMethod` (`methodId`),
  CONSTRAINT `methodIdPaperMethod` FOREIGN KEY (`methodId`) REFERENCES `method` (`methodId`),
  CONSTRAINT `paperIdPaperMethod` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
  `taskId` int NOT NULL AUTO_INCREMENT,
  `taskDesc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`taskId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
