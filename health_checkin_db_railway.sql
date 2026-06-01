/*
 Navicat Premium Dump SQL

 Source Server         : health_checkin_db
 Source Server Type    : MySQL
 Source Server Version : 80045 (8.0.45)
 Source Host           : localhost:3306
 Source Schema         : health_checkin_db

 Target Server Type    : MySQL
 Target Server Version : 80045 (8.0.45)
 File Encoding         : 65001

 Date: 01/06/2026 21:21:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_alert_notify_record
-- ----------------------------
DROP TABLE IF EXISTS `t_alert_notify_record`;
CREATE TABLE `t_alert_notify_record`  (
  `notify_id` int NOT NULL AUTO_INCREMENT COMMENT '閫氱煡缂栧彿',
  `alert_id` int NOT NULL COMMENT '寮傚父缂栧彿',
  `contact_id` int NOT NULL COMMENT '鑱旂郴浜虹紪鍙?,
  `notify_method` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '绯荤粺閫氱煡' COMMENT '閫氱煡鏂瑰紡锛氱郴缁熼€氱煡/鐭俊/鐢佃瘽/閭欢',
  `notify_content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '閫氱煡鍐呭',
  `notify_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '鏈彂閫? COMMENT '閫氱煡鐘舵€侊細鏈彂閫?宸插彂閫?鍙戦€佸け璐?,
  `notify_time` datetime NULL DEFAULT NULL COMMENT '閫氱煡鏃堕棿',
  PRIMARY KEY (`notify_id`) USING BTREE,
  INDEX `fk_notify_alert`(`alert_id` ASC) USING BTREE,
  INDEX `fk_notify_contact`(`contact_id` ASC) USING BTREE,
  CONSTRAINT `fk_notify_alert` FOREIGN KEY (`alert_id`) REFERENCES `t_alert_record` (`alert_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_notify_contact` FOREIGN KEY (`contact_id`) REFERENCES `t_emergency_contact` (`contact_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '寮傚父閫氱煡璁板綍琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_alert_notify_record
-- ----------------------------
INSERT INTO `t_alert_notify_record` VALUES (1, 1, 1, '绯荤粺閫氱煡', '寮犱笁鐨勬瘡鏃ユ姤骞冲畨浠诲姟鍦?026-06-02鏈墦鍗★紝璇峰強鏃惰仈绯荤‘璁ゅ畨鍏ㄦ儏鍐点€?, '宸插彂閫?, '2026-06-02 21:10:00');
INSERT INTO `t_alert_notify_record` VALUES (2, 1, 2, '绯荤粺閫氱煡', '寮犱笁鐨勬瘡鏃ユ姤骞冲畨浠诲姟鍦?026-06-02鏈墦鍗★紝璇峰強鏃惰仈绯荤‘璁ゅ畨鍏ㄦ儏鍐点€?, '宸插彂閫?, '2026-06-02 21:10:00');
INSERT INTO `t_alert_notify_record` VALUES (3, 2, 3, '绯荤粺閫氱煡', '鏉庡ザ濂剁殑闄嶅帇鑽悆鑽墦鍗′换鍔″凡杩炵画2澶╂湭鎵撳崱锛岃鍙婃椂纭鏈嶈嵂鎯呭喌銆?, '宸插彂閫?, '2026-06-02 08:30:00');
INSERT INTO `t_alert_notify_record` VALUES (4, 2, 4, '绯荤粺閫氱煡', '鏉庡ザ濂剁殑闄嶅帇鑽悆鑽墦鍗′换鍔″凡杩炵画2澶╂湭鎵撳崱锛岃鍙婃椂纭鏈嶈嵂鎯呭喌銆?, '宸插彂閫?, '2026-06-02 08:30:00');

-- ----------------------------
-- Table structure for t_alert_record
-- ----------------------------
DROP TABLE IF EXISTS `t_alert_record`;
CREATE TABLE `t_alert_record`  (
  `alert_id` int NOT NULL AUTO_INCREMENT COMMENT '寮傚父缂栧彿',
  `task_id` int NOT NULL COMMENT '浠诲姟缂栧彿',
  `alert_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '寮傚父绫诲瀷锛氭湭鎵撳崱/瓒呮椂鎵撳崱/杩炵画鏈墦鍗?,
  `alert_date` date NOT NULL COMMENT '寮傚父鏃ユ湡',
  `alert_content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '寮傚父鍐呭',
  `handle_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '鏈鐞? COMMENT '澶勭悊鐘舵€侊細鏈鐞?宸插鐞?,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  PRIMARY KEY (`alert_id`) USING BTREE,
  INDEX `fk_alert_task`(`task_id` ASC) USING BTREE,
  CONSTRAINT `fk_alert_task` FOREIGN KEY (`task_id`) REFERENCES `t_checkin_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '寮傚父璁板綍琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_alert_record
-- ----------------------------
INSERT INTO `t_alert_record` VALUES (1, 1, '鏈墦鍗?, '2026-06-02', '寮犱笁鐨勬瘡鏃ユ姤骞冲畨浠诲姟鍦?026-06-02鏈墦鍗★紝宸茶揪鍒?澶╂湭鎵撳崱寮傚父瑙勫垯', '鏈鐞?, '2026-05-31 18:53:45');
INSERT INTO `t_alert_record` VALUES (2, 2, '杩炵画鏈墦鍗?, '2026-06-02', '鏉庡ザ濂剁殑闄嶅帇鑽悆鑽墦鍗′换鍔¤繛缁?澶╂湭鎵撳崱锛屼笖宸插紑鍚€佷汉妯″紡', '鏈鐞?, '2026-05-31 18:53:45');
INSERT INTO `t_alert_record` VALUES (3, 3, '杩炵画鏈墦鍗?, '2026-06-04', '寮犱笁鐨勮窇姝ュ仴韬墦鍗′换鍔¤繛缁?澶╂湭鎵撳崱锛屽凡杈惧埌鍋ヨ韩浠诲姟寮傚父瑙勫垯', '鏈鐞?, '2026-05-31 18:53:45');

-- ----------------------------
-- Table structure for t_checkin_record
-- ----------------------------
DROP TABLE IF EXISTS `t_checkin_record`;
CREATE TABLE `t_checkin_record`  (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '璁板綍缂栧彿',
  `task_id` int NOT NULL COMMENT '浠诲姟缂栧彿',
  `checkin_date` date NOT NULL COMMENT '鎵撳崱鏃ユ湡',
  `checkin_time` datetime NULL DEFAULT NULL COMMENT '瀹為檯鎵撳崱鏃堕棿',
  `checkin_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鎵撳崱鐘舵€侊細宸插畬鎴?瓒呮椂瀹屾垚/鏈畬鎴?,
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '澶囨敞',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '璁板綍鍒涘缓鏃堕棿',
  PRIMARY KEY (`record_id`) USING BTREE,
  UNIQUE INDEX `uk_task_date`(`task_id` ASC, `checkin_date` ASC) USING BTREE,
  CONSTRAINT `fk_record_task` FOREIGN KEY (`task_id`) REFERENCES `t_checkin_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鎵撳崱璁板綍琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_checkin_record
-- ----------------------------
INSERT INTO `t_checkin_record` VALUES (1, 1, '2026-05-31', '2026-05-31 20:50:00', '宸插畬鎴?, '浠婃棩姝ｅ父鎶ュ钩瀹?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (2, 1, '2026-06-01', '2026-06-01 14:16:22', '宸插畬鎴?, '鐢ㄦ埛閫氳繃绯荤粺鏇存柊浠婃棩鎵撳崱', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (3, 1, '2026-06-02', NULL, '鏈畬鎴?, '褰撳ぉ鏈姤骞冲畨', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (4, 2, '2026-05-31', '2026-05-31 08:05:00', '宸插畬鎴?, '宸叉寜鏃跺悆鑽?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (5, 2, '2026-06-01', NULL, '鏈畬鎴?, '褰撳ぉ鏈墦鍗?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (6, 2, '2026-06-02', NULL, '鏈畬鎴?, '杩炵画绗簩澶╂湭鎵撳崱', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (7, 3, '2026-05-31', NULL, '鏈畬鎴?, '鏈繘琛屽仴韬墦鍗?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (8, 3, '2026-06-01', '2026-06-01 14:16:16', '宸插畬鎴?, '鐢ㄦ埛閫氳繃绯荤粺鏇存柊浠婃棩鎵撳崱', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (9, 3, '2026-06-02', NULL, '鏈畬鎴?, '鏈繘琛屽仴韬墦鍗?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (10, 3, '2026-06-03', NULL, '鏈畬鎴?, '鏈繘琛屽仴韬墦鍗?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (11, 3, '2026-06-04', NULL, '鏈畬鎴?, '杩炵画绗簲澶╂湭鍋ヨ韩鎵撳崱', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (12, 4, '2026-05-31', '2026-05-31 21:50:00', '宸插畬鎴?, '宸插畬鎴愭櫄闂存姢鑲?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (13, 4, '2026-06-01', NULL, '鏈畬鎴?, '褰撳ぉ鏈姢鑲ゆ墦鍗?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (14, 4, '2026-06-02', '2026-06-02 22:10:00', '瓒呮椂瀹屾垚', '鏅氫簬鐩爣鏃堕棿瀹屾垚鎶よ偆', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (15, 5, '2026-05-31', '2026-05-31 22:45:00', '宸插畬鎴?, '鎸夋椂鏃╃潯', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (16, 5, '2026-06-01', '2026-06-01 23:20:00', '瓒呮椂瀹屾垚', '鏅氫簬23鐐圭潯瑙?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (17, 5, '2026-06-02', NULL, '鏈畬鎴?, '褰撳ぉ鏈棭鐫℃墦鍗?, '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (22, 7, '2026-06-01', '2026-06-01 15:36:00', '宸插畬鎴?, '鐢ㄦ埛閫氳繃绯荤粺瀹屾垚浠婃棩鎵撳崱', '2026-06-01 15:36:00');
INSERT INTO `t_checkin_record` VALUES (23, 8, '2026-06-01', '2026-06-01 15:47:41', '宸插畬鎴?, '鐢ㄦ埛閫氳繃绯荤粺瀹屾垚浠婃棩鎵撳崱', '2026-06-01 15:47:41');
INSERT INTO `t_checkin_record` VALUES (24, 9, '2026-06-01', '2026-06-01 15:52:52', '宸插畬鎴?, '鐢ㄦ埛閫氳繃绯荤粺瀹屾垚浠婃棩鎵撳崱', '2026-06-01 15:52:52');

-- ----------------------------
-- Table structure for t_checkin_task
-- ----------------------------
DROP TABLE IF EXISTS `t_checkin_task`;
CREATE TABLE `t_checkin_task`  (
  `task_id` int NOT NULL AUTO_INCREMENT COMMENT '浠诲姟缂栧彿',
  `user_id` int NOT NULL COMMENT '鐢ㄦ埛缂栧彿',
  `type_id` int NOT NULL COMMENT '鎵撳崱绫诲瀷缂栧彿',
  `task_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '浠诲姟鍚嶇О',
  `target_time` time NULL DEFAULT NULL COMMENT '鐩爣鎵撳崱鏃堕棿',
  `start_date` date NOT NULL COMMENT '寮€濮嬫棩鏈?,
  `end_date` date NULL DEFAULT NULL COMMENT '缁撴潫鏃ユ湡',
  `frequency` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '姣忔棩' COMMENT '鎵撳崱棰戠巼',
  `elder_mode` tinyint NOT NULL DEFAULT 0 COMMENT '鑰佷汉妯″紡锛?鍚︼紝1鏄?,
  `task_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '杩涜涓? COMMENT '浠诲姟鐘舵€侊細杩涜涓?宸茬粨鏉?鍋滅敤',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '鍒涘缓鏃堕棿',
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `fk_task_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_task_type`(`type_id` ASC) USING BTREE,
  CONSTRAINT `fk_task_type` FOREIGN KEY (`type_id`) REFERENCES `t_checkin_type` (`type_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_user` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鎵撳崱浠诲姟琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_checkin_task
-- ----------------------------
INSERT INTO `t_checkin_task` VALUES (1, 2, 2, '姣忔棩鎶ュ钩瀹?, '21:00:00', '2026-05-31', '2026-06-30', '姣忔棩', 0, '杩涜涓?, '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (2, 3, 1, '闄嶅帇鑽悆鑽墦鍗?, '08:00:00', '2026-05-31', '2026-06-30', '姣忔棩', 1, '杩涜涓?, '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (3, 2, 4, '璺戞鍋ヨ韩鎵撳崱', '18:30:00', '2026-05-31', '2026-06-30', '姣忔棩', 0, '杩涜涓?, '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (4, 4, 3, '鏅氶棿鎶よ偆鎵撳崱', '22:00:00', '2026-05-31', '2026-06-30', '姣忔棩', 0, '杩涜涓?, '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (5, 4, 5, '鏃╃潯鎵撳崱', '23:00:00', '2026-05-31', '2026-06-30', '姣忔棩', 0, '杩涜涓?, '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (6, 2, 1, '姣忔棩鏃╃潯鎵撳崱', '23:59:00', '2026-06-01', '2026-09-01', '姣忔棩', 0, '杩涜涓?, '2026-06-01 14:29:49');
INSERT INTO `t_checkin_task` VALUES (7, 5, 3, '鏅氶棿鎶よ偆鎵撳崱', '23:30:00', '2026-06-01', '2026-12-31', '姣忔棩', 0, '杩涜涓?, '2026-06-01 14:53:22');
INSERT INTO `t_checkin_task` VALUES (8, 7, 1, '姣忔棩鍚冭嵂鎵撳崱', '13:30:00', '2026-06-02', '2026-07-31', '姣忔棩', 1, '杩涜涓?, '2026-06-01 15:45:44');
INSERT INTO `t_checkin_task` VALUES (9, 9, 4, '鍋ヨ韩', '07:01:00', '2026-06-01', '2026-07-01', '姣忔棩', 0, '杩涜涓?, '2026-06-01 15:52:49');

-- ----------------------------
-- Table structure for t_checkin_type
-- ----------------------------
DROP TABLE IF EXISTS `t_checkin_type`;
CREATE TABLE `t_checkin_type`  (
  `type_id` int NOT NULL AUTO_INCREMENT COMMENT '绫诲瀷缂栧彿',
  `type_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '绫诲瀷鍚嶇О',
  `type_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '绫诲瀷璇存槑',
  `default_miss_days` int NOT NULL COMMENT '榛樿杩炵画鏈墦鍗″紓甯稿ぉ鏁?,
  `default_notify_contact` tinyint NOT NULL DEFAULT 0 COMMENT '榛樿鏄惁閫氱煡绱ф€ヨ仈绯讳汉锛?鍚︼紝1鏄?,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '鍚敤' COMMENT '鐘舵€侊細鍚敤/鍋滅敤',
  PRIMARY KEY (`type_id`) USING BTREE,
  UNIQUE INDEX `type_name`(`type_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鎵撳崱绫诲瀷琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_checkin_type
-- ----------------------------
INSERT INTO `t_checkin_type` VALUES (1, '鍚冭嵂', '璁板綍鐢ㄦ埛姣忔棩鍚冭嵂鎯呭喌锛屽紑鍚€佷汉妯″紡鍚庡紓甯搁€氱煡绱ф€ヨ仈绯讳汉', 2, 0, '鍚敤');
INSERT INTO `t_checkin_type` VALUES (2, '鎶ュ钩瀹?, '璁板綍鐢ㄦ埛姣忔棩鎶ュ钩瀹夋儏鍐碉紝寮傚父鏃堕€氱煡绱ф€ヨ仈绯讳汉', 1, 1, '鍚敤');
INSERT INTO `t_checkin_type` VALUES (3, '鎶よ偆', '璁板綍鐢ㄦ埛姣忔棩鎶よ偆鎵撳崱鎯呭喌', 3, 0, '鍚敤');
INSERT INTO `t_checkin_type` VALUES (4, '鍋ヨ韩', '璁板綍鐢ㄦ埛鍋ヨ韩鎵撳崱鎯呭喌', 5, 0, '鍚敤');
INSERT INTO `t_checkin_type` VALUES (5, '鏃╃潯', '璁板綍鐢ㄦ埛鏃╃潯涔犳儻鎵撳崱鎯呭喌', 3, 0, '鍚敤');

-- ----------------------------
-- Table structure for t_emergency_contact
-- ----------------------------
DROP TABLE IF EXISTS `t_emergency_contact`;
CREATE TABLE `t_emergency_contact`  (
  `contact_id` int NOT NULL AUTO_INCREMENT COMMENT '鑱旂郴浜虹紪鍙?,
  `user_id` int NOT NULL COMMENT '鐢ㄦ埛缂栧彿',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鑱旂郴浜哄鍚?,
  `relationship` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '涓庣敤鎴峰叧绯?,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '鑱旂郴浜烘墜鏈哄彿',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '鑱旂郴浜洪偖绠?,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '鍚敤' COMMENT '鐘舵€侊細鍚敤/鍋滅敤',
  PRIMARY KEY (`contact_id`) USING BTREE,
  INDEX `fk_contact_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_contact_user` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '绱ф€ヨ仈绯讳汉琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_emergency_contact
-- ----------------------------
INSERT INTO `t_emergency_contact` VALUES (1, 2, '寮犱笁濡堝', '姣嶄翰', '13911112222', 'zhangsan_mother@example.com', '鍚敤');
INSERT INTO `t_emergency_contact` VALUES (2, 2, '寮犱笁鏈嬪弸', '鏈嬪弸', '13911113333', 'zhangsan_friend@example.com', '鍚敤');
INSERT INTO `t_emergency_contact` VALUES (3, 3, '鏉庡ザ濂跺効瀛?, '鍎垮瓙', '13933334444', 'linainai_son@example.com', '鍚敤');
INSERT INTO `t_emergency_contact` VALUES (4, 3, '鏉庡ザ濂跺コ鍎?, '濂冲効', '13933335555', 'linainai_daughter@example.com', '鍚敤');
INSERT INTO `t_emergency_contact` VALUES (5, 4, '鐜嬩簲濮愬', '濮愬', '13955556666', 'wangwu_sister@example.com', '鍚敤');
INSERT INTO `t_emergency_contact` VALUES (6, 2, '寮犱笁鍝ュ摜', '鍏勫紵', '13855556666', '32562895@qq.com', '鍚敤');

-- ----------------------------
-- Table structure for t_reminder_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_reminder_rule`;
CREATE TABLE `t_reminder_rule`  (
  `rule_id` int NOT NULL AUTO_INCREMENT COMMENT '瑙勫垯缂栧彿',
  `task_id` int NOT NULL COMMENT '浠诲姟缂栧彿',
  `remind_time` time NULL DEFAULT NULL COMMENT '姣忔棩鎻愰啋鏃堕棿',
  `miss_days_threshold` int NOT NULL COMMENT '杩炵画鏈墦鍗″紓甯搁槇鍊?,
  `notify_contact` tinyint NOT NULL DEFAULT 0 COMMENT '寮傚父鏃舵槸鍚﹂€氱煡绱ф€ヨ仈绯讳汉锛?鍚︼紝1鏄?,
  `is_enabled` tinyint NOT NULL DEFAULT 1 COMMENT '鏄惁鍚敤锛?鍚︼紝1鏄?,
  `rule_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '瑙勫垯璇存槑',
  PRIMARY KEY (`rule_id`) USING BTREE,
  INDEX `fk_rule_task`(`task_id` ASC) USING BTREE,
  CONSTRAINT `fk_rule_task` FOREIGN KEY (`task_id`) REFERENCES `t_checkin_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鎻愰啋瑙勫垯琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_reminder_rule
-- ----------------------------
INSERT INTO `t_reminder_rule` VALUES (1, 1, '21:00:00', 1, 1, 1, '鎶ュ钩瀹変换鍔★細1澶╂湭鎵撳崱鐢熸垚寮傚父锛屽苟閫氱煡绱ф€ヨ仈绯讳汉');
INSERT INTO `t_reminder_rule` VALUES (2, 2, '08:00:00', 2, 1, 1, '鍚冭嵂浠诲姟锛氬紑鍚€佷汉妯″紡锛?澶╂湭鎵撳崱鐢熸垚寮傚父锛屽苟閫氱煡绱ф€ヨ仈绯讳汉');
INSERT INTO `t_reminder_rule` VALUES (3, 3, '18:30:00', 5, 0, 1, '鍋ヨ韩浠诲姟锛?澶╂湭鎵撳崱鐢熸垚寮傚父');
INSERT INTO `t_reminder_rule` VALUES (4, 4, '22:00:00', 3, 0, 1, '鎶よ偆浠诲姟锛?澶╂湭鎵撳崱鐢熸垚寮傚父');
INSERT INTO `t_reminder_rule` VALUES (5, 5, '23:00:00', 3, 0, 1, '鏃╃潯浠诲姟锛?澶╂湭鎵撳崱鐢熸垚寮傚父');
INSERT INTO `t_reminder_rule` VALUES (6, 6, '23:59:00', 2, 0, 1, '鍚冭嵂浠诲姟锛氳繛缁?澶╂湭鎵撳崱鐢熸垚寮傚父');
INSERT INTO `t_reminder_rule` VALUES (7, 7, '23:30:00', 3, 0, 1, '鎶よ偆浠诲姟锛氳繛缁?澶╂湭鎵撳崱鐢熸垚寮傚父');
INSERT INTO `t_reminder_rule` VALUES (8, 8, '13:30:00', 2, 1, 1, '鍚冭嵂浠诲姟锛氳繛缁?澶╂湭鎵撳崱鐢熸垚寮傚父锛屽苟閫氱煡绱ф€ヨ仈绯讳汉');
INSERT INTO `t_reminder_rule` VALUES (9, 9, '07:01:00', 5, 0, 1, '鍋ヨ韩浠诲姟锛氳繛缁?澶╂湭鎵撳崱鐢熸垚寮傚父');

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '鐢ㄦ埛缂栧彿',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鐢ㄦ埛鍚?,
  `user_password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '鐢ㄦ埛瀵嗙爜',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '鎵嬫満鍙?,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '鎬у埆',
  `age` int NULL DEFAULT NULL COMMENT '骞撮緞',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '鐢ㄦ埛' COMMENT '瑙掕壊锛氱敤鎴?绠＄悊鍛?,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '姝ｅ父' COMMENT '璐﹀彿鐘舵€侊細姝ｅ父/绂佺敤',
  `register_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '娉ㄥ唽鏃堕棿',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '鐢ㄦ埛琛? ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (1, 'admin', '123456', '13800000000', '鐢?, 30, '绠＄悊鍛?, '姝ｅ父', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (2, 'zhangsan', '123456', '13811112222', '鐢?, 21, '鐢ㄦ埛', '姝ｅ父', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (3, 'linainai', '123456', '13833334444', '濂?, 72, '鐢ㄦ埛', '姝ｅ父', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (4, 'wangwu', '123456', '13855556666', '濂?, 24, '鐢ㄦ埛', '姝ｅ父', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (5, 'HL', '060322', '19845166009', '濂?, 20, '鐢ㄦ埛', '姝ｅ父', '2026-06-01 14:52:23');
INSERT INTO `t_user` VALUES (6, '灏忚寽', '1qaz2wsx', '18800215277', '濂?, 20, '鐢ㄦ埛', '姝ｅ父', '2026-06-01 15:31:39');
INSERT INTO `t_user` VALUES (7, 'hhg', 'hhg6571996', '13836056767', '鐢?, 50, '鐢ㄦ埛', '姝ｅ父', '2026-06-01 15:38:06');
INSERT INTO `t_user` VALUES (8, 'HYQ', 'HYQ123456', '18946190005', '濂?, 48, '鐢ㄦ埛', '姝ｅ父', '2026-06-01 15:45:51');
INSERT INTO `t_user` VALUES (9, 'HYQHYQ', 'HYQ123456', '18946190005', '濂?, 48, '鐢ㄦ埛', '姝ｅ父', '2026-06-01 15:48:23');

SET FOREIGN_KEY_CHECKS = 1;
