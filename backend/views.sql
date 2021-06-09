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

-- ----------------------------
-- View structure for v_benchext
-- ----------------------------
DROP VIEW IF EXISTS `v_benchext`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_benchext` AS select `be`.`benchId` AS `benchId`,`be`.`metric` AS `metric`,`be`.`taskId` AS `taskId`,`be`.`taskName` AS `taskName`,`be`.`datasetId` AS `datasetId`,`d`.`datasetName` AS `datasetName` from ((select `b`.`benchId` AS `benchId`,`b`.`metric` AS `metric`,`b`.`taskId` AS `taskId`,`t`.`taskName` AS `taskName`,`b`.`datasetId` AS `datasetId` from (`benchmark` `b` join `task` `t` on((`b`.`taskId` = `t`.`taskId`)))) `be` join `dataset` `d` on((`be`.`datasetId` = `d`.`datasetId`))) ;

-- ----------------------------
-- View structure for v_paperstar
-- ----------------------------
DROP VIEW IF EXISTS `v_paperstar`;
CREATE ALGORITHM=UNDEFINED DEFINER=`DB_USER012`@`%` SQL SECURITY DEFINER VIEW `v_paperstar` AS select `paper`.`title` AS `title`,`paper`.`paperLink` AS `paperLink`,`paper`.`abs` AS `abs`,`paper`.`publishDate` AS `publishDate`,sum(`code`.`stars`) AS `star` from (`paper` join `code` on((`paper`.`paperId` = `code`.`paperId`))) ;
