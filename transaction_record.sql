/*
 Navicat MySQL Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 50736
 Source Host           : localhost:3306
 Source Schema         : portfolio_manager

 Target Server Type    : MySQL
 Target Server Version : 50736
 File Encoding         : 65001

 Date: 30/07/2025 11:07:50
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for transaction_record
-- ----------------------------
DROP TABLE IF EXISTS `transaction_record`;
CREATE TABLE `transaction_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '流水ID，主键，自动递增',
  `portfolio_id` int(11) NOT NULL COMMENT '所属组合ID，逻辑关联 portfolio 表',
  `type` enum('BUY','SELL','DIVIDEND','TRANSFER_IN','TRANSFER_OUT') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '交易类型：买入/卖出/分红/转入/转出',
  `asset_type` enum('STOCK','BOND','ETF','CASH','OTHER') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '资产类型，与 asset 表一致',
  `symbol` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '资产代码（如股票代码AAPL）',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资产名称',
  `quantity` decimal(18, 2) NOT NULL COMMENT '交易数量（买入为正，卖出也为正）',
  `price` decimal(18, 2) NOT NULL COMMENT '单价',
  `amount` decimal(18, 2) GENERATED ALWAYS AS ((`quantity` * `price`)) STORED COMMENT '交易总金额，自动生成' NULL,
  `currency` varchar(3) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'USD' COMMENT '币种，默认USD',
  `trade_date` date NOT NULL COMMENT '交易日期',
  `note` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注信息，如佣金、分红说明等',
  `created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `updated_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_portfolio`(`portfolio_id`) USING BTREE,
  INDEX `idx_symbol`(`symbol`) USING BTREE,
  INDEX `idx_trade_date`(`trade_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '资产交易流水表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of transaction_record
-- ----------------------------
INSERT INTO `transaction_record` VALUES (1, 1, 'BUY', 'STOCK', 'JNJ', '强生公司', 50.00, 165.30, DEFAULT, 'USD', '2023-01-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (2, 1, 'BUY', 'BOND', 'US10Y', '美国10年期国债', 1000.00, 98.50, DEFAULT, 'USD', '2023-02-20', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (3, 1, 'BUY', 'CASH', 'USD', '美元现金', 50000.00, 1.00, DEFAULT, 'USD', '2023-03-01', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (4, 2, 'BUY', 'STOCK', 'AAPL', '苹果公司', 30.00, 145.80, DEFAULT, 'USD', '2023-01-10', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (5, 2, 'BUY', 'STOCK', 'MSFT', '微软公司', 20.00, 245.60, DEFAULT, 'USD', '2023-02-05', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (6, 2, 'BUY', 'STOCK', 'GOOGL', 'Alphabet A类股', 15.00, 102.75, DEFAULT, 'USD', '2023-03-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (7, 3, 'BUY', 'ETF', 'VTI', 'Vanguard全股市ETF', 45.00, 215.40, DEFAULT, 'USD', '2023-01-20', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (8, 3, 'BUY', 'ETF', 'BND', 'Vanguard全债市ETF', 800.00, 79.85, DEFAULT, 'USD', '2023-02-10', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (9, 3, 'BUY', 'ETF', 'VXUS', 'Vanguard国际股市ETF', 60.00, 55.30, DEFAULT, 'USD', '2023-03-05', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (10, 4, 'BUY', 'BOND', 'CORP', '公司债券', 5000.00, 100.00, DEFAULT, 'USD', '2023-01-25', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (11, 4, 'BUY', 'BOND', 'MUNI', '市政债券', 3000.00, 100.00, DEFAULT, 'USD', '2023-02-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (12, 4, 'BUY', 'CASH', 'USD', '美元现金', 20000.00, 1.00, DEFAULT, 'USD', '2023-03-10', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (13, 5, 'BUY', 'STOCK', 'TSLA', '特斯拉公司', 10.00, 180.50, DEFAULT, 'USD', '2023-01-05', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (14, 5, 'BUY', 'STOCK', 'NVDA', '英伟达公司', 25.00, 220.40, DEFAULT, 'USD', '2023-02-25', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (15, 5, 'BUY', 'ETF', 'ARKK', 'ARK创新ETF', 100.00, 45.60, DEFAULT, 'USD', '2023-03-20', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (16, 2, 'SELL', 'STOCK', 'AAPL', '苹果公司', 10.00, 172.00, DEFAULT, 'USD', '2024-05-01', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (17, 2, 'SELL', 'STOCK', 'GOOGL', 'Alphabet A类股', 5.00, 120.00, DEFAULT, 'USD', '2024-06-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (18, 3, 'SELL', 'ETF', 'VTI', 'Vanguard全股市ETF', 20.00, 230.00, DEFAULT, 'USD', '2025-07-16', NULL, '2025-07-29 16:52:31', '2025-07-30 11:07:01');
INSERT INTO `transaction_record` VALUES (19, 5, 'SELL', 'STOCK', 'TSLA', '特斯拉公司', 5.00, 220.00, DEFAULT, 'USD', '2025-07-11', NULL, '2025-07-29 16:52:31', '2025-07-30 11:06:44');
INSERT INTO `transaction_record` VALUES (20, 5, 'SELL', 'ETF', 'ARKK', 'ARK创新ETF', 40.00, 55.00, DEFAULT, 'USD', '2025-07-01', NULL, '2025-07-29 16:52:31', '2025-07-30 11:06:50');

SET FOREIGN_KEY_CHECKS = 1;
