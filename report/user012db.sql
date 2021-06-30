/*
Navicat MySQL Data Transfer

Source Server         : 124.71.228.59_3306
Source Server Version : 80018
Source Host           : 124.71.228.59:3306
Source Database       : user012db

Target Server Type    : MYSQL
Target Server Version : 80018
File Encoding         : 65001

Date: 2021-06-30 16:42:42
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for method
-- ----------------------------
DROP TABLE IF EXISTS `method`;
CREATE TABLE `method` (
  `methodId` int(11) NOT NULL AUTO_INCREMENT,
  `methodName` varchar(255) NOT NULL,
  `methodDesc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`methodId`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

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
  `score` decimal(12,4) NOT NULL,
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

-- ----------------------------
-- View structure for v_author_of_paper
-- ----------------------------
DROP VIEW IF EXISTS `v_author_of_paper`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_author_of_paper` (`paperId`,`authorId`,`authorName`,`ord`) AS select `p`.`paperId` AS `paperId`,`a`.`authorId` AS `authorId`,`a`.`authorName` AS `authorName`,`pa`.`ord` AS `ord` from ((`paperauthor` `pa` join `author` `a`) join `paper` `p`) where ((`pa`.`authorId` = `a`.`authorId`) and (`pa`.`paperId` = `p`.`paperId`)) ;

-- ----------------------------
-- View structure for v_benchmark_details
-- ----------------------------
DROP VIEW IF EXISTS `v_benchmark_details`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_benchmark_details` (`benchId`,`taskId`,`datasetId`,`metric`,`taskName`,`datasetName`,`datasetLink`) AS select `b`.`benchId` AS `benchId`,`b`.`taskId` AS `taskId`,`b`.`datasetId` AS `datasetId`,`b`.`metric` AS `metric`,`t`.`taskName` AS `taskName`,`d`.`datasetName` AS `datasetName`,`d`.`datasetLink` AS `datasetLink` from ((`benchmark` `b` join `task` `t`) join `dataset` `d`) where ((`t`.`taskId` = `b`.`taskId`) and (`d`.`datasetId` = `b`.`datasetId`)) ;

-- ----------------------------
-- View structure for v_bench_best
-- ----------------------------
DROP VIEW IF EXISTS `v_bench_best`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_bench_best` (`paperId`,`benchId`,`score`,`modelDesc`) AS select `paperbench`.`paperId` AS `paperId`,`paperbench`.`benchId` AS `benchId`,`paperbench`.`score` AS `score`,`paperbench`.`modelDesc` AS `modelDesc` from `paperbench` where (`paperbench`.`benchId`,`paperbench`.`score`) in (select `paperbench`.`benchId`,max(`paperbench`.`score`) from `paperbench` group by `paperbench`.`benchId`) ;

-- ----------------------------
-- View structure for v_bench_of_paper
-- ----------------------------
DROP VIEW IF EXISTS `v_bench_of_paper`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_bench_of_paper` (`paperId`,`benchId`,`taskId`,`datasetId`,`metric`,`taskName`,`datasetName`) AS select `p`.`paperId` AS `paperId`,`b`.`benchId` AS `benchId`,`b`.`taskId` AS `taskId`,`b`.`datasetId` AS `datasetId`,`b`.`metric` AS `metric`,`b`.`taskName` AS `taskName`,`b`.`datasetName` AS `datasetName` from ((`paperbench` `pb` join `v_benchmark_details` `b`) join `paper` `p`) where ((`pb`.`benchId` = `b`.`benchId`) and (`pb`.`paperId` = `p`.`paperId`)) ;

-- ----------------------------
-- View structure for v_bestbench_of_task
-- ----------------------------
DROP VIEW IF EXISTS `v_bestbench_of_task`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_bestbench_of_task` (`title`,`benchId`,`paperId`,`metric`,`datasetName`,`datasetId`,`taskName`,`taskDesc`,`codeLink`,`modelDesc`) AS select `paper`.`title` AS `title`,`v_bench_best`.`benchId` AS `benchId`,`paper`.`paperId` AS `paperId`,`v_benchmark_details`.`metric` AS `metric`,`v_benchmark_details`.`datasetName` AS `datasetName`,`v_benchmark_details`.`datasetId` AS `datasetId`,`t`.`taskName` AS `taskName`,`t`.`taskDesc` AS `taskDesc`,`v_fircode_paper`.`codeLink` AS `codeLink`,`v_bench_best`.`modelDesc` AS `modelDesc` from ((((`paper` join `v_bench_best` on((`paper`.`paperId` = `v_bench_best`.`paperId`))) join `v_benchmark_details` on((`v_bench_best`.`benchId` = `v_benchmark_details`.`benchId`))) join `task` `t` on((`v_benchmark_details`.`taskId` = `t`.`taskId`))) join `v_fircode_paper` on((`paper`.`paperId` = `v_fircode_paper`.`paperId`))) ;

-- ----------------------------
-- View structure for v_code_of_paper
-- ----------------------------
DROP VIEW IF EXISTS `v_code_of_paper`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_code_of_paper` (`codeId`,`paperId`,`codeLink`,`stars`,`framework`) AS select `c`.`codeId` AS `codeId`,`c`.`paperId` AS `paperId`,`c`.`codeLink` AS `codeLink`,`c`.`stars` AS `stars`,`c`.`framework` AS `framework` from (`paper` `p` join `code` `c` on((`p`.`paperId` = `c`.`paperId`))) ;

-- ----------------------------
-- View structure for v_dataset_papercount
-- ----------------------------
DROP VIEW IF EXISTS `v_dataset_papercount`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_dataset_papercount` (`datasetDesc`,`datasetLink`,`createDate`,`datasetName`,`taskName`,`paperCnt`,`datasetId`) AS select `d`.`datasetDesc` AS `datasetDesc`,`d`.`datasetLink` AS `datasetLink`,`d`.`createDate` AS `createDate`,`d`.`datasetName` AS `datasetName`,`t`.`taskName` AS `taskName`,count(distinct `p`.`paperId`) AS `count(DISTINCT paperId)`,`d`.`datasetId` AS `datasetId` from (((`dataset` `d` join `benchmark` `b` on((`d`.`datasetId` = `b`.`datasetId`))) join `paperbench` `p` on((`b`.`benchId` = `p`.`benchId`))) join `task` `t` on((`b`.`taskId` = `t`.`taskId`))) group by `d`.`datasetId` ;

-- ----------------------------
-- View structure for v_fircode_paper
-- ----------------------------
DROP VIEW IF EXISTS `v_fircode_paper`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_fircode_paper` (`paperId`,`codeLink`) AS select `v_code_of_paper`.`paperId` AS `paperId`,`v_code_of_paper`.`codeLink` AS `codeLink` from `v_code_of_paper` group by `v_code_of_paper`.`paperId` ;

-- ----------------------------
-- View structure for v_method_of_paper
-- ----------------------------
DROP VIEW IF EXISTS `v_method_of_paper`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_method_of_paper` (`paperId`,`methodId`,`methodName`) AS select `p`.`paperId` AS `paperId`,`m`.`methodId` AS `methodId`,`m`.`methodName` AS `methodName` from ((`papermethod` `pm` join `method` `m`) join `paper` `p`) where ((`pm`.`methodId` = `m`.`methodId`) and (`pm`.`paperId` = `p`.`paperId`)) ;

-- ----------------------------
-- View structure for v_method_papercount
-- ----------------------------
DROP VIEW IF EXISTS `v_method_papercount`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_method_papercount` (`methodName`,`methodDesc`,`taskName`,`paperCnt`) AS select `m`.`methodName` AS `methodName`,`m`.`methodDesc` AS `methodDesc`,`t`.`taskName` AS `taskName`,count(distinct `v`.`paperId`) AS `count(DISTINCT paperId)` from ((`v_method_of_paper` `v` join `method` `m` on((`v`.`methodId` = `m`.`methodId`))) join `v_task_of_paper` `t` on((`v`.`paperId` = `t`.`paperId`))) group by `m`.`methodName` ;

-- ----------------------------
-- View structure for v_paperstar
-- ----------------------------
DROP VIEW IF EXISTS `v_paperstar`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_paperstar` AS select `paper`.`paperId` AS `id`,`paper`.`title` AS `title`,`paper`.`paperLink` AS `paperLink`,`paper`.`abs` AS `abs`,`paper`.`publishDate` AS `publishDate`,sum(`code`.`stars`) AS `star` from (`paper` join `code` on((`paper`.`paperId` = `code`.`paperId`))) group by `paper`.`paperId` ;

-- ----------------------------
-- View structure for v_paper_of_bench
-- ----------------------------
DROP VIEW IF EXISTS `v_paper_of_bench`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_paper_of_bench` (`title`,`paperLink`,`metric`,`score`) AS select `p`.`title` AS `title`,`p`.`paperLink` AS `paperLink`,`b`.`metric` AS `metric`,`pb`.`score` AS `score` from ((`benchmark` `b` join `paperbench` `pb` on((`b`.`benchId` = `pb`.`benchId`))) join `paper` `p` on((`pb`.`paperId` = `p`.`paperId`))) group by `b`.`benchId` ;

-- ----------------------------
-- View structure for v_task_benchcount
-- ----------------------------
DROP VIEW IF EXISTS `v_task_benchcount`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_task_benchcount` (`taskId`,`benchCnt`) AS select `t`.`taskId` AS `taskId`,count(distinct `v`.`metric`) AS `count(DISTINCT metric)` from (`v_bestbench_of_task` `v` join `task` `t` on((`v`.`taskName` = `t`.`taskName`))) group by `v`.`taskName` ;

-- ----------------------------
-- View structure for v_task_of_paper
-- ----------------------------
DROP VIEW IF EXISTS `v_task_of_paper`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_task_of_paper` (`paperId`,`title`,`taskName`,`taskDesc`) AS select distinct `p`.`paperId` AS `paperId`,`p`.`title` AS `title`,`t`.`taskName` AS `taskName`,`t`.`taskDesc` AS `taskDesc` from (((`paper` `p` join `paperbench` `pb` on((`p`.`paperId` = `pb`.`paperId`))) join `benchmark` `b` on((`pb`.`benchId` = `b`.`benchId`))) join `task` `t` on((`b`.`taskId` = `t`.`taskId`))) ;

-- ----------------------------
-- View structure for v_task_papercount
-- ----------------------------
DROP VIEW IF EXISTS `v_task_papercount`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_task_papercount` (`taskId`,`taskName`,`taskDesc`,`paperCnt`) AS select `t`.`taskId` AS `taskId`,`t`.`taskName` AS `taskName`,`t`.`taskDesc` AS `taskDesc`,count(distinct `p`.`paperId`) AS `count(DISTINCT paperId)` from ((`paperbench` `p` join `benchmark` `b` on((`p`.`benchId` = `b`.`benchId`))) join `task` `t` on((`b`.`taskId` = `t`.`taskId`))) group by `t`.`taskName` ;
