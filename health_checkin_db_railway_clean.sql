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
  `notify_id` int NOT NULL AUTO_INCREMENT COMMENT '通知编号',
  `alert_id` int NOT NULL COMMENT '异常编号',
  `contact_id` int NOT NULL COMMENT '联系人编号',
  `notify_method` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '系统通知' COMMENT '通知方式：系统通知/短信/电话/邮件',
  `notify_content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '通知内容',
  `notify_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '未发送' COMMENT '通知状态：未发送/已发送/发送失败',
  `notify_time` datetime NULL DEFAULT NULL COMMENT '通知时间',
  PRIMARY KEY (`notify_id`) USING BTREE,
  INDEX `fk_notify_alert`(`alert_id` ASC) USING BTREE,
  INDEX `fk_notify_contact`(`contact_id` ASC) USING BTREE,
  CONSTRAINT `fk_notify_alert` FOREIGN KEY (`alert_id`) REFERENCES `t_alert_record` (`alert_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_notify_contact` FOREIGN KEY (`contact_id`) REFERENCES `t_emergency_contact` (`contact_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '异常通知记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_alert_notify_record
-- ----------------------------
INSERT INTO `t_alert_notify_record` VALUES (1, 1, 1, '系统通知', '张三的每日报平安任务在2026-06-02未打卡，请及时联系确认安全情况。', '已发送', '2026-06-02 21:10:00');
INSERT INTO `t_alert_notify_record` VALUES (2, 1, 2, '系统通知', '张三的每日报平安任务在2026-06-02未打卡，请及时联系确认安全情况。', '已发送', '2026-06-02 21:10:00');
INSERT INTO `t_alert_notify_record` VALUES (3, 2, 3, '系统通知', '李奶奶的降压药吃药打卡任务已连续2天未打卡，请及时确认服药情况。', '已发送', '2026-06-02 08:30:00');
INSERT INTO `t_alert_notify_record` VALUES (4, 2, 4, '系统通知', '李奶奶的降压药吃药打卡任务已连续2天未打卡，请及时确认服药情况。', '已发送', '2026-06-02 08:30:00');

-- ----------------------------
-- Table structure for t_alert_record
-- ----------------------------
DROP TABLE IF EXISTS `t_alert_record`;
CREATE TABLE `t_alert_record`  (
  `alert_id` int NOT NULL AUTO_INCREMENT COMMENT '异常编号',
  `task_id` int NOT NULL COMMENT '任务编号',
  `alert_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '异常类型：未打卡/超时打卡/连续未打卡',
  `alert_date` date NOT NULL COMMENT '异常日期',
  `alert_content` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '异常内容',
  `handle_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '未处理' COMMENT '处理状态：未处理/已处理',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`alert_id`) USING BTREE,
  INDEX `fk_alert_task`(`task_id` ASC) USING BTREE,
  CONSTRAINT `fk_alert_task` FOREIGN KEY (`task_id`) REFERENCES `t_checkin_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '异常记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_alert_record
-- ----------------------------
INSERT INTO `t_alert_record` VALUES (1, 1, '未打卡', '2026-06-02', '张三的每日报平安任务在2026-06-02未打卡，已达到1天未打卡异常规则', '未处理', '2026-05-31 18:53:45');
INSERT INTO `t_alert_record` VALUES (2, 2, '连续未打卡', '2026-06-02', '李奶奶的降压药吃药打卡任务连续2天未打卡，且已开启老人模式', '未处理', '2026-05-31 18:53:45');
INSERT INTO `t_alert_record` VALUES (3, 3, '连续未打卡', '2026-06-04', '张三的跑步健身打卡任务连续5天未打卡，已达到健身任务异常规则', '未处理', '2026-05-31 18:53:45');

-- ----------------------------
-- Table structure for t_checkin_record
-- ----------------------------
DROP TABLE IF EXISTS `t_checkin_record`;
CREATE TABLE `t_checkin_record`  (
  `record_id` int NOT NULL AUTO_INCREMENT COMMENT '记录编号',
  `task_id` int NOT NULL COMMENT '任务编号',
  `checkin_date` date NOT NULL COMMENT '打卡日期',
  `checkin_time` datetime NULL DEFAULT NULL COMMENT '实际打卡时间',
  `checkin_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '打卡状态：已完成/超时完成/未完成',
  `remark` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  PRIMARY KEY (`record_id`) USING BTREE,
  UNIQUE INDEX `uk_task_date`(`task_id` ASC, `checkin_date` ASC) USING BTREE,
  CONSTRAINT `fk_record_task` FOREIGN KEY (`task_id`) REFERENCES `t_checkin_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '打卡记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_checkin_record
-- ----------------------------
INSERT INTO `t_checkin_record` VALUES (1, 1, '2026-05-31', '2026-05-31 20:50:00', '已完成', '今日正常报平安', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (2, 1, '2026-06-01', '2026-06-01 14:16:22', '已完成', '用户通过系统更新今日打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (3, 1, '2026-06-02', NULL, '未完成', '当天未报平安', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (4, 2, '2026-05-31', '2026-05-31 08:05:00', '已完成', '已按时吃药', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (5, 2, '2026-06-01', NULL, '未完成', '当天未打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (6, 2, '2026-06-02', NULL, '未完成', '连续第二天未打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (7, 3, '2026-05-31', NULL, '未完成', '未进行健身打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (8, 3, '2026-06-01', '2026-06-01 14:16:16', '已完成', '用户通过系统更新今日打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (9, 3, '2026-06-02', NULL, '未完成', '未进行健身打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (10, 3, '2026-06-03', NULL, '未完成', '未进行健身打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (11, 3, '2026-06-04', NULL, '未完成', '连续第五天未健身打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (12, 4, '2026-05-31', '2026-05-31 21:50:00', '已完成', '已完成晚间护肤', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (13, 4, '2026-06-01', NULL, '未完成', '当天未护肤打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (14, 4, '2026-06-02', '2026-06-02 22:10:00', '超时完成', '晚于目标时间完成护肤', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (15, 5, '2026-05-31', '2026-05-31 22:45:00', '已完成', '按时早睡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (16, 5, '2026-06-01', '2026-06-01 23:20:00', '超时完成', '晚于23点睡觉', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (17, 5, '2026-06-02', NULL, '未完成', '当天未早睡打卡', '2026-05-31 18:52:51');
INSERT INTO `t_checkin_record` VALUES (22, 7, '2026-06-01', '2026-06-01 15:36:00', '已完成', '用户通过系统完成今日打卡', '2026-06-01 15:36:00');
INSERT INTO `t_checkin_record` VALUES (23, 8, '2026-06-01', '2026-06-01 15:47:41', '已完成', '用户通过系统完成今日打卡', '2026-06-01 15:47:41');
INSERT INTO `t_checkin_record` VALUES (24, 9, '2026-06-01', '2026-06-01 15:52:52', '已完成', '用户通过系统完成今日打卡', '2026-06-01 15:52:52');

-- ----------------------------
-- Table structure for t_checkin_task
-- ----------------------------
DROP TABLE IF EXISTS `t_checkin_task`;
CREATE TABLE `t_checkin_task`  (
  `task_id` int NOT NULL AUTO_INCREMENT COMMENT '任务编号',
  `user_id` int NOT NULL COMMENT '用户编号',
  `type_id` int NOT NULL COMMENT '打卡类型编号',
  `task_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
  `target_time` time NULL DEFAULT NULL COMMENT '目标打卡时间',
  `start_date` date NOT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `frequency` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '每日' COMMENT '打卡频率',
  `elder_mode` tinyint NOT NULL DEFAULT 0 COMMENT '老人模式：0否，1是',
  `task_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '进行中' COMMENT '任务状态：进行中/已结束/停用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`task_id`) USING BTREE,
  INDEX `fk_task_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_task_type`(`type_id` ASC) USING BTREE,
  CONSTRAINT `fk_task_type` FOREIGN KEY (`type_id`) REFERENCES `t_checkin_type` (`type_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_task_user` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '打卡任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_checkin_task
-- ----------------------------
INSERT INTO `t_checkin_task` VALUES (1, 2, 2, '每日报平安', '21:00:00', '2026-05-31', '2026-06-30', '每日', 0, '进行中', '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (2, 3, 1, '降压药吃药打卡', '08:00:00', '2026-05-31', '2026-06-30', '每日', 1, '进行中', '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (3, 2, 4, '跑步健身打卡', '18:30:00', '2026-05-31', '2026-06-30', '每日', 0, '进行中', '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (4, 4, 3, '晚间护肤打卡', '22:00:00', '2026-05-31', '2026-06-30', '每日', 0, '进行中', '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (5, 4, 5, '早睡打卡', '23:00:00', '2026-05-31', '2026-06-30', '每日', 0, '进行中', '2026-05-31 18:51:37');
INSERT INTO `t_checkin_task` VALUES (6, 2, 1, '每日早睡打卡', '23:59:00', '2026-06-01', '2026-09-01', '每日', 0, '进行中', '2026-06-01 14:29:49');
INSERT INTO `t_checkin_task` VALUES (7, 5, 3, '晚间护肤打卡', '23:30:00', '2026-06-01', '2026-12-31', '每日', 0, '进行中', '2026-06-01 14:53:22');
INSERT INTO `t_checkin_task` VALUES (8, 7, 1, '每日吃药打卡', '13:30:00', '2026-06-02', '2026-07-31', '每日', 1, '进行中', '2026-06-01 15:45:44');
INSERT INTO `t_checkin_task` VALUES (9, 9, 4, '健身', '07:01:00', '2026-06-01', '2026-07-01', '每日', 0, '进行中', '2026-06-01 15:52:49');

-- ----------------------------
-- Table structure for t_checkin_type
-- ----------------------------
DROP TABLE IF EXISTS `t_checkin_type`;
CREATE TABLE `t_checkin_type`  (
  `type_id` int NOT NULL AUTO_INCREMENT COMMENT '类型编号',
  `type_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型名称',
  `type_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '类型说明',
  `default_miss_days` int NOT NULL COMMENT '默认连续未打卡异常天数',
  `default_notify_contact` tinyint NOT NULL DEFAULT 0 COMMENT '默认是否通知紧急联系人：0否，1是',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '启用' COMMENT '状态：启用/停用',
  PRIMARY KEY (`type_id`) USING BTREE,
  UNIQUE INDEX `type_name`(`type_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '打卡类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_checkin_type
-- ----------------------------
INSERT INTO `t_checkin_type` VALUES (1, '吃药', '记录用户每日吃药情况，开启老人模式后异常通知紧急联系人', 2, 0, '启用');
INSERT INTO `t_checkin_type` VALUES (2, '报平安', '记录用户每日报平安情况，异常时通知紧急联系人', 1, 1, '启用');
INSERT INTO `t_checkin_type` VALUES (3, '护肤', '记录用户每日护肤打卡情况', 3, 0, '启用');
INSERT INTO `t_checkin_type` VALUES (4, '健身', '记录用户健身打卡情况', 5, 0, '启用');
INSERT INTO `t_checkin_type` VALUES (5, '早睡', '记录用户早睡习惯打卡情况', 3, 0, '启用');

-- ----------------------------
-- Table structure for t_emergency_contact
-- ----------------------------
DROP TABLE IF EXISTS `t_emergency_contact`;
CREATE TABLE `t_emergency_contact`  (
  `contact_id` int NOT NULL AUTO_INCREMENT COMMENT '联系人编号',
  `user_id` int NOT NULL COMMENT '用户编号',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系人姓名',
  `relationship` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '与用户关系',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人邮箱',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '启用' COMMENT '状态：启用/停用',
  PRIMARY KEY (`contact_id`) USING BTREE,
  INDEX `fk_contact_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_contact_user` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '紧急联系人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_emergency_contact
-- ----------------------------
INSERT INTO `t_emergency_contact` VALUES (1, 2, '张三妈妈', '母亲', '13911112222', 'zhangsan_mother@example.com', '启用');
INSERT INTO `t_emergency_contact` VALUES (2, 2, '张三朋友', '朋友', '13911113333', 'zhangsan_friend@example.com', '启用');
INSERT INTO `t_emergency_contact` VALUES (3, 3, '李奶奶儿子', '儿子', '13933334444', 'linainai_son@example.com', '启用');
INSERT INTO `t_emergency_contact` VALUES (4, 3, '李奶奶女儿', '女儿', '13933335555', 'linainai_daughter@example.com', '启用');
INSERT INTO `t_emergency_contact` VALUES (5, 4, '王五姐姐', '姐姐', '13955556666', 'wangwu_sister@example.com', '启用');
INSERT INTO `t_emergency_contact` VALUES (6, 2, '张三哥哥', '兄弟', '13855556666', '32562895@qq.com', '启用');

-- ----------------------------
-- Table structure for t_reminder_rule
-- ----------------------------
DROP TABLE IF EXISTS `t_reminder_rule`;
CREATE TABLE `t_reminder_rule`  (
  `rule_id` int NOT NULL AUTO_INCREMENT COMMENT '规则编号',
  `task_id` int NOT NULL COMMENT '任务编号',
  `remind_time` time NULL DEFAULT NULL COMMENT '每日提醒时间',
  `miss_days_threshold` int NOT NULL COMMENT '连续未打卡异常阈值',
  `notify_contact` tinyint NOT NULL DEFAULT 0 COMMENT '异常时是否通知紧急联系人：0否，1是',
  `is_enabled` tinyint NOT NULL DEFAULT 1 COMMENT '是否启用：0否，1是',
  `rule_desc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规则说明',
  PRIMARY KEY (`rule_id`) USING BTREE,
  INDEX `fk_rule_task`(`task_id` ASC) USING BTREE,
  CONSTRAINT `fk_rule_task` FOREIGN KEY (`task_id`) REFERENCES `t_checkin_task` (`task_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '提醒规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_reminder_rule
-- ----------------------------
INSERT INTO `t_reminder_rule` VALUES (1, 1, '21:00:00', 1, 1, 1, '报平安任务：1天未打卡生成异常，并通知紧急联系人');
INSERT INTO `t_reminder_rule` VALUES (2, 2, '08:00:00', 2, 1, 1, '吃药任务：开启老人模式，2天未打卡生成异常，并通知紧急联系人');
INSERT INTO `t_reminder_rule` VALUES (3, 3, '18:30:00', 5, 0, 1, '健身任务：5天未打卡生成异常');
INSERT INTO `t_reminder_rule` VALUES (4, 4, '22:00:00', 3, 0, 1, '护肤任务：3天未打卡生成异常');
INSERT INTO `t_reminder_rule` VALUES (5, 5, '23:00:00', 3, 0, 1, '早睡任务：3天未打卡生成异常');
INSERT INTO `t_reminder_rule` VALUES (6, 6, '23:59:00', 2, 0, 1, '吃药任务：连续2天未打卡生成异常');
INSERT INTO `t_reminder_rule` VALUES (7, 7, '23:30:00', 3, 0, 1, '护肤任务：连续3天未打卡生成异常');
INSERT INTO `t_reminder_rule` VALUES (8, 8, '13:30:00', 2, 1, 1, '吃药任务：连续2天未打卡生成异常，并通知紧急联系人');
INSERT INTO `t_reminder_rule` VALUES (9, 9, '07:01:00', 5, 0, 1, '健身任务：连续5天未打卡生成异常');

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `user_password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户密码',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '性别',
  `age` int NULL DEFAULT NULL COMMENT '年龄',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '用户' COMMENT '角色：用户/管理员',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '正常' COMMENT '账号状态：正常/禁用',
  `register_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_user
-- ----------------------------
INSERT INTO `t_user` VALUES (1, 'admin', '123456', '13800000000', '男', 30, '管理员', '正常', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (2, 'zhangsan', '123456', '13811112222', '男', 21, '用户', '正常', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (3, 'linainai', '123456', '13833334444', '女', 72, '用户', '正常', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (4, 'wangwu', '123456', '13855556666', '女', 24, '用户', '正常', '2026-05-31 18:50:08');
INSERT INTO `t_user` VALUES (5, 'HL', '060322', '19845166009', '女', 20, '用户', '正常', '2026-06-01 14:52:23');
INSERT INTO `t_user` VALUES (6, '小茜', '1qaz2wsx', '18800215277', '女', 20, '用户', '正常', '2026-06-01 15:31:39');
INSERT INTO `t_user` VALUES (7, 'hhg', 'hhg6571996', '13836056767', '男', 50, '用户', '正常', '2026-06-01 15:38:06');
INSERT INTO `t_user` VALUES (8, 'HYQ', 'HYQ123456', '18946190005', '女', 48, '用户', '正常', '2026-06-01 15:45:51');
INSERT INTO `t_user` VALUES (9, 'HYQHYQ', 'HYQ123456', '18946190005', '女', 48, '用户', '正常', '2026-06-01 15:48:23');

SET FOREIGN_KEY_CHECKS = 1;