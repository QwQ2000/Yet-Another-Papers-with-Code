/*
Navicat MySQL Data Transfer

Source Server         : 124.71.228.59_3306
Source Server Version : 80018
Source Host           : 124.71.228.59:3306
Source Database       : user012db

Target Server Type    : MYSQL
Target Server Version : 80018
File Encoding         : 65001

Date: 2021-06-09 09:52:47
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for author
-- ----------------------------
DROP TABLE IF EXISTS `author`;
CREATE TABLE `author` (
  `authorId` int(11) NOT NULL AUTO_INCREMENT,
  `authorName` varchar(255) NOT NULL,
  `inst` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`authorId`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for benchmark
-- ----------------------------
DROP TABLE IF EXISTS `benchmark`;
CREATE TABLE `benchmark` (
  `benchId` int(11) NOT NULL AUTO_INCREMENT,
  `metric` varchar(255) NOT NULL,
  `datasetId` int(11) NOT NULL,
  `taskId` int(11) NOT NULL,
  PRIMARY KEY (`benchId`),
  KEY `datasetOfBench` (`datasetId`),
  KEY `taskOfBench` (`taskId`),
  CONSTRAINT `datasetOfBench` FOREIGN KEY (`datasetId`) REFERENCES `dataset` (`datasetId`),
  CONSTRAINT `taskOfBench` FOREIGN KEY (`taskId`) REFERENCES `task` (`taskId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for code
-- ----------------------------
DROP TABLE IF EXISTS `code`;
CREATE TABLE `code` (
  `codeId` int(11) NOT NULL AUTO_INCREMENT,
  `paperId` int(11) NOT NULL,
  `codeLink` varchar(255) NOT NULL,
  `stars` int(11) NOT NULL,
  `framework` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`codeId`),
  KEY `codeOfPaper` (`paperId`),
  CONSTRAINT `codeOfPaper` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for dataset
-- ----------------------------
DROP TABLE IF EXISTS `dataset`;
CREATE TABLE `dataset` (
  `datasetId` int(11) NOT NULL AUTO_INCREMENT,
  `datasetDesc` varchar(255) DEFAULT NULL,
  `datasetLink` varchar(255) NOT NULL,
  `createDate` date NOT NULL,
  `datasetName` varchar(255) NOT NULL,
  PRIMARY KEY (`datasetId`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for method
-- ----------------------------
DROP TABLE IF EXISTS `method`;
CREATE TABLE `method` (
  `methodId` int(11) NOT NULL AUTO_INCREMENT,
  `methodName` varchar(255) NOT NULL,
  `methodDesc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`methodId`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for paper
-- ----------------------------
DROP TABLE IF EXISTS `paper`;
CREATE TABLE `paper` (
  `paperId` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `paperLink` varchar(255) NOT NULL,
  `abs` varchar(255) NOT NULL,
  `publishDate` date NOT NULL,
  PRIMARY KEY (`paperId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for paperauthor
-- ----------------------------
DROP TABLE IF EXISTS `paperauthor`;
CREATE TABLE `paperauthor` (
  `paperId` int(11) NOT NULL,
  `authorId` int(11) NOT NULL,
  `ord` int(11) NOT NULL,
  `iscorr` int(11) NOT NULL,
  PRIMARY KEY (`paperId`,`authorId`),
  KEY `authorIdPaperAuthor` (`authorId`),
  CONSTRAINT `authorIdPaperAuthor` FOREIGN KEY (`authorId`) REFERENCES `author` (`authorId`) ON UPDATE RESTRICT,
  CONSTRAINT `paperIdPaperAuthor` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for paperbench
-- ----------------------------
DROP TABLE IF EXISTS `paperbench`;
CREATE TABLE `paperbench` (
  `paperId` int(11) NOT NULL,
  `benchId` int(11) NOT NULL,
  `score` decimal(3,3) NOT NULL,
  `modelDesc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`paperId`,`benchId`),
  KEY `benchIdPaperBench` (`benchId`),
  CONSTRAINT `benchIdPaperBench` FOREIGN KEY (`benchId`) REFERENCES `benchmark` (`benchId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `paperIdPaperBench` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for papermethod
-- ----------------------------
DROP TABLE IF EXISTS `papermethod`;
CREATE TABLE `papermethod` (
  `paperId` int(11) NOT NULL,
  `methodId` int(11) NOT NULL,
  PRIMARY KEY (`paperId`,`methodId`),
  KEY `methodIdPaperMethod` (`methodId`),
  CONSTRAINT `methodIdPaperMethod` FOREIGN KEY (`methodId`) REFERENCES `method` (`methodId`),
  CONSTRAINT `paperIdPaperMethod` FOREIGN KEY (`paperId`) REFERENCES `paper` (`paperId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for task
-- ----------------------------
DROP TABLE IF EXISTS `task`;
CREATE TABLE `task` (
  `taskId` int(11) NOT NULL AUTO_INCREMENT,
  `taskDesc` varchar(255) DEFAULT NULL,
  `taskName` varchar(255) NOT NULL,
  PRIMARY KEY (`taskId`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
