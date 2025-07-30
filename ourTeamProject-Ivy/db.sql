-- 创建数据库
CREATE DATABASE IF NOT EXISTS portfolio_manager;
USE portfolio_manager;

/*
 * 投资组合表
 * 存储投资组合的基本信息
 */
CREATE TABLE IF NOT EXISTS portfolio (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '组合ID，主键，自动递增',
    name VARCHAR(100) NOT NULL COMMENT '组合名称，不能为空',
    description TEXT COMMENT '组合描述信息',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间'
) COMMENT '投资组合主表';

/*
 * 资产表
 * 存储各类资产信息，通过portfolio_id关联到投资组合
 * 不使用物理外键约束，通过应用层维护数据完整性
 */
CREATE TABLE IF NOT EXISTS asset (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '资产ID，主键，自动递增',
    portfolio_id INT NOT NULL COMMENT '所属组合ID，逻辑关联portfolio表',
    type ENUM('STOCK','BOND','ETF','CASH','OTHER') NOT NULL COMMENT '资产类型：股票/债券/ETF/现金/其他',
    symbol VARCHAR(20) NOT NULL COMMENT '资产代码（如股票代码AAPL）',
    name VARCHAR(100) COMMENT '资产名称',
    quantity DECIMAL(18,4) NOT NULL COMMENT '持有数量',
    purchase_price DECIMAL(18,4) COMMENT '买入价格',
    current_price DECIMAL(18,4) COMMENT '当前价格',
    purchase_date DATE COMMENT '买入日期',
    currency VARCHAR(3) DEFAULT 'USD' COMMENT '货币类型，默认USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
    INDEX idx_portfolio (portfolio_id) COMMENT '组合ID索引',
    INDEX idx_symbol (symbol) COMMENT '资产代码索引'
) COMMENT '资产明细表';

/*
 * 组合表现记录表
 * 存储组合的历史表现数据
 */
CREATE TABLE IF NOT EXISTS portfolio_performance (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '记录ID',
    portfolio_id INT NOT NULL COMMENT '关联的组合ID',
    record_date DATE NOT NULL COMMENT '记录日期',
    total_value DECIMAL(18,4) NOT NULL COMMENT '组合总价值',
    daily_return DECIMAL(10,4) COMMENT '日收益率',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_portfolio_date (portfolio_id, record_date) COMMENT '组合ID和日期的唯一约束'
) COMMENT '组合表现历史表';

-- 插入示例数据

-- 投资组合数据
INSERT INTO portfolio (name, description) VALUES 
('稳健增长组合', '以蓝筹股和债券为主的保守型投资组合'),
('科技先锋组合', '专注于科技行业成长型股票的投资组合'),
('全球均衡配置', '跨市场、跨资产类别的多元化投资组合'),
('固定收益组合', '以债券和固定收益产品为主的组合'),
('高成长组合', '投资于新兴市场和高增长潜力公司的组合');

-- 资产数据
INSERT INTO asset (
    portfolio_id, type, symbol, name, quantity, purchase_price, current_price, purchase_date, currency
) VALUES
-- 稳健增长组合的资产
(1, 'STOCK', 'JNJ', '强生公司', 50, 165.30, 168.45, '2023-01-15', 'USD'),
(1, 'BOND', 'US10Y', '美国10年期国债', 1000, 98.50, 97.80, '2023-02-20', 'USD'),
(1, 'CASH', 'USD', '美元现金', 50000, 1, 1, '2023-03-01', 'USD'),

-- 科技先锋组合的资产
(2, 'STOCK', 'AAPL', '苹果公司', 30, 145.80, 175.25, '2023-01-10', 'USD'),
(2, 'STOCK', 'MSFT', '微软公司', 20, 245.60, 310.50, '2023-02-05', 'USD'),
(2, 'STOCK', 'GOOGL', 'Alphabet A类股', 15, 102.75, 125.40, '2023-03-15', 'USD'),

-- 全球均衡配置的资产
(3, 'ETF', 'VTI', 'Vanguard全股市ETF', 45, 215.40, 225.30, '2023-01-20', 'USD'),
(3, 'ETF', 'BND', 'Vanguard全债市ETF', 800, 79.85, 78.90, '2023-02-10', 'USD'),
(3, 'ETF', 'VXUS', 'Vanguard国际股市ETF', 60, 55.30, 58.75, '2023-03-05', 'USD'),

-- 固定收益组合的资产
(4, 'BOND', 'CORP', '公司债券', 5000, 100, 101.25, '2023-01-25', 'USD'),
(4, 'BOND', 'MUNI', '市政债券', 3000, 100, 99.80, '2023-02-15', 'USD'),
(4, 'CASH', 'USD', '美元现金', 20000, 1, 1, '2023-03-10', 'USD'),

-- 高成长组合的资产
(5, 'STOCK', 'TSLA', '特斯拉公司', 10, 180.50, 210.75, '2023-01-05', 'USD'),
(5, 'STOCK', 'NVDA', '英伟达公司', 25, 220.40, 280.30, '2023-02-25', 'USD'),
(5, 'ETF', 'ARKK', 'ARK创新ETF', 100, 45.60, 50.25, '2023-03-20', 'USD');

-- 组合表现数据
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return) VALUES
(1, '2023-04-01', 75000, 0.0052),
(1, '2023-04-02', 75250, 0.0033),
(1, '2023-04-03', 75500, 0.0033),
(2, '2023-04-01', 85000, 0.0085),
(2, '2023-04-02', 84500, -0.0059),
(2, '2023-04-03', 84800, 0.0036),
(3, '2023-04-01', 92000, 0.0043),
(3, '2023-04-02', 92500, 0.0054),
(3, '2023-04-03', 92300, -0.0022),
(4, '2023-04-01', 68000, 0.0015),
(4, '2023-04-02', 68050, 0.0007),
(4, '2023-04-03', 68100, 0.0007),
(5, '2023-04-01', 95000, 0.0120),
(5, '2023-04-02', 94000, -0.0105),
(5, '2023-04-03', 94500, 0.0053);


INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return) VALUES
(1, '2023-04-01', 75000.0000, 0.0052),
(1, '2023-04-02', 75250.0000, 0.0033),
(1, '2023-04-03', 75500.0000, 0.0033),
(2, '2023-04-01', 85000.0000, 0.0085),
(2, '2023-04-02', 84500.0000, -0.0059),
(2, '2023-04-03', 84800.0000, 0.0036),
(3, '2023-04-01', 92000.0000, 0.0043),
(3, '2023-04-02', 92500.0000, 0.0054),
(3, '2023-04-03', 92300.0000, -0.0022),
(4, '2023-04-01', 68000.0000, 0.0015),
(4, '2023-04-02', 68050.0000, 0.0007),
(4, '2023-04-03', 68100.0000, 0.0007),
(5, '2023-04-01', 95000.0000, 0.0120),
(5, '2023-04-02', 94000.0000, -0.0105),
(5, '2023-04-03', 94500.0000, 0.0053);

-- 为每个组合生成37天的额外数据（共40天，从4月4日到5月10日）
-- 组合1 (ID=1) 数据生成
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return)
WITH RECURSIVE dates AS (
  SELECT '2023-04-04' AS date
  UNION ALL
  SELECT DATE_ADD(date, INTERVAL 1 DAY) FROM dates WHERE date < '2023-05-10'
)
SELECT 
  1 AS portfolio_id,
  date AS record_date,
  ROUND(75500 * POWER(1.0033, DAY(date) - 3) * (1 + (RAND() * 0.006 - 0.003)), 4) AS total_value,
  ROUND(0.0033 + (RAND() * 0.006 - 0.003), 4) AS daily_return
FROM dates;

-- 组合2 (ID=2) 数据生成
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return)
WITH RECURSIVE dates AS (
  SELECT '2023-04-04' AS date
  UNION ALL
  SELECT DATE_ADD(date, INTERVAL 1 DAY) FROM dates WHERE date < '2023-05-10'
)
SELECT 
  2 AS portfolio_id,
  date AS record_date,
  ROUND(84800 * POWER(1.0036, DAY(date) - 3) * (1 + (RAND() * 0.008 - 0.004)), 4) AS total_value,
  ROUND(0.0036 + (RAND() * 0.008 - 0.004), 4) AS daily_return
FROM dates;

-- 组合3 (ID=3) 数据生成
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return)
WITH RECURSIVE dates AS (
  SELECT '2023-04-04' AS date
  UNION ALL
  SELECT DATE_ADD(date, INTERVAL 1 DAY) FROM dates WHERE date < '2023-05-10'
)
SELECT 
  3 AS portfolio_id,
  date AS record_date,
  ROUND(92300 * POWER(0.998, DAY(date) - 3) * (1 + (RAND() * 0.007 - 0.0035)), 4) AS total_value,
  ROUND(-0.0022 + (RAND() * 0.007 - 0.0035), 4) AS daily_return
FROM dates;

-- 组合4 (ID=4) 数据生成
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return)
WITH RECURSIVE dates AS (
  SELECT '2023-04-04' AS date
  UNION ALL
  SELECT DATE_ADD(date, INTERVAL 1 DAY) FROM dates WHERE date < '2023-05-10'
)
SELECT 
  4 AS portfolio_id,
  date AS record_date,
  ROUND(68100 * POWER(1.0007, DAY(date) - 3) * (1 + (RAND() * 0.002 - 0.001)), 4) AS total_value,
  ROUND(0.0007 + (RAND() * 0.002 - 0.001), 4) AS daily_return
FROM dates;

-- 组合5 (ID=5) 数据生成
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return)
WITH RECURSIVE dates AS (
  SELECT '2023-04-04' AS date
  UNION ALL
  SELECT DATE_ADD(date, INTERVAL 1 DAY) FROM dates WHERE date < '2023-05-10'
)
SELECT 
  5 AS portfolio_id,
  date AS record_date,
  ROUND(94500 * POWER(1.0053, DAY(date) - 3) * (1 + (RAND() * 0.01 - 0.005)), 4) AS total_value,
  ROUND(0.0053 + (RAND() * 0.01 - 0.005), 4) AS daily_return
FROM dates;




CREATE TABLE IF NOT EXISTS market (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '市场ID，主键，自动递增',
    type ENUM('STOCK','BOND','ETF','CASH','OTHER') NOT NULL COMMENT '类型：股票/债券/ETF/现金/其他',
    symbol VARCHAR(20) NOT NULL COMMENT '代码（如股票代码AAPL）',
    name VARCHAR(100) COMMENT '名称',
    current_price DECIMAL(18,4) COMMENT '当前价格',
    currency VARCHAR(3) DEFAULT 'USD' COMMENT '类型，默认USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_symbol (symbol) COMMENT '代码索引'
) COMMENT '市场明细表';

-- 股票类型数据
INSERT INTO market (type, symbol, name, current_price, currency) VALUES
('STOCK', 'AAPL', 'Apple Inc.', 175.50, 'USD'),
('STOCK', 'MSFT', 'Microsoft Corporation', 330.25, 'USD'),
('STOCK', 'AMZN', 'Amazon.com Inc.', 145.75, 'USD'),
('STOCK', 'TSLA', 'Tesla Inc.', 700.80, 'USD'),
('STOCK', 'GOOGL', 'Alphabet Inc.', 135.40, 'USD'),
('STOCK', 'BABA', 'Alibaba Group', 85.60, 'USD'),
('STOCK', 'TSM', 'Taiwan Semiconductor', 95.45, 'USD'),
('STOCK', '005930', 'Samsung Electronics', 71500.00, 'KRW'),
('STOCK', '000858', 'Wuliangye', 165.30, 'CNY');

-- 债券类型数据
INSERT INTO market (type, symbol, name, current_price, currency) VALUES
('BOND', 'US10Y', 'US 10 Year Treasury', 98.75, 'USD'),
('BOND', 'US2Y', 'US 2 Year Treasury', 99.50, 'USD'),
('BOND', 'DE10Y', 'Germany 10 Year Bund', 102.30, 'EUR'),
('BOND', 'JP10Y', 'Japan 10 Year JGB', 99.80, 'JPY');

-- ETF类型数据
INSERT INTO market (type, symbol, name, current_price, currency) VALUES
('ETF', 'SPY', 'SPDR S&P 500 ETF', 415.20, 'USD'),
('ETF', 'QQQ', 'Invesco QQQ Trust', 350.75, 'USD'),
('ETF', 'VTI', 'Vanguard Total Stock Market', 215.60, 'USD'),
('ETF', 'EEM', 'iShares MSCI Emerging Markets', 40.25, 'USD'),
('ETF', 'GLD', 'SPDR Gold Shares', 180.50, 'USD');

-- 现金和其他类型数据
INSERT INTO market (type, symbol, name, current_price, currency) VALUES
('CASH', 'USD', 'US Dollar', 1.0000, 'USD'),
('CASH', 'EUR', 'Euro', 0.9200, 'USD'),
('CASH', 'JPY', 'Japanese Yen', 0.0075, 'USD'),
('CASH', 'CNY', 'Chinese Yuan', 0.1450, 'USD'),
('OTHER', 'BTC', 'Bitcoin', 42000.00, 'USD'),
('OTHER', 'ETH', 'Ethereum', 2250.50, 'USD'),
('OTHER', 'XAU', 'Gold Spot', 1950.75, 'USD');


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