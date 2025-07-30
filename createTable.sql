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


-- 创建用户表，用于存储用户账户信息
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户唯一标识ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名，用于登录和显示',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '用户电子邮箱(唯一)',
    initial_amount DECIMAL(15, 2) NOT NULL DEFAULT 0.00 COMMENT '用户初始金额',
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0) COMMENT '当前账户余额(必须≥0)',
    currency VARCHAR(3) DEFAULT 'USD' COMMENT '货币类型(如USD,CNY等)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '账户创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间'
) COMMENT='用户账户信息表';

INSERT INTO user (username, email, initial_amount, balance)
VALUES ('john_doe', 'john.doe@example.com', 10000.00, 10000.00);

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
