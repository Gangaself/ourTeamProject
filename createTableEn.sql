-- Create database
CREATE DATABASE IF NOT EXISTS portfolio_manager;
USE portfolio_manager;

/*
 * Portfolio Table
 * Stores basic information about investment portfolios
 */
CREATE TABLE IF NOT EXISTS portfolio (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Portfolio ID, primary key, auto-increment',
    name VARCHAR(100) NOT NULL COMMENT 'Portfolio name, cannot be empty',
    description TEXT COMMENT 'Portfolio description',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time'
) COMMENT 'Main portfolio table';

/*
 * Asset Table
 * Stores asset information, linked to portfolios via portfolio_id
 * Uses application-level integrity instead of physical foreign keys
 */
CREATE TABLE IF NOT EXISTS asset (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Asset ID, primary key, auto-increment',
    portfolio_id INT NOT NULL COMMENT 'Owning portfolio ID, logical link to portfolio table',
    type ENUM('STOCK','BOND','ETF','CASH','OTHER') NOT NULL COMMENT 'Asset type: stock/bond/ETF/cash/other',
    symbol VARCHAR(20) NOT NULL COMMENT 'Asset symbol (e.g., AAPL stock symbol)',
    name VARCHAR(100) COMMENT 'Asset name',
    quantity DECIMAL(18,4) NOT NULL COMMENT 'Holding quantity',
    purchase_price DECIMAL(18,4) COMMENT 'Purchase price',
    current_price DECIMAL(18,4) COMMENT 'Current price',
    purchase_date DATE COMMENT 'Purchase date',
    currency VARCHAR(3) DEFAULT 'USD' COMMENT 'Currency type, default USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time',
    INDEX idx_portfolio (portfolio_id) COMMENT 'Portfolio ID index',
    INDEX idx_symbol (symbol) COMMENT 'Asset symbol index'
) COMMENT 'Asset details table';

/*
 * Portfolio Performance Table
 * Stores historical performance data of portfolios
 */
CREATE TABLE IF NOT EXISTS portfolio_performance (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Record ID',
    portfolio_id INT NOT NULL COMMENT 'Associated portfolio ID',
    record_date DATE NOT NULL COMMENT 'Record date',
    total_value DECIMAL(18,4) NOT NULL COMMENT 'Total portfolio value',
    daily_return DECIMAL(10,4) COMMENT 'Daily return rate',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    UNIQUE KEY uk_portfolio_date (portfolio_id, record_date) COMMENT 'Unique constraint on portfolio ID and date'
) COMMENT 'Portfolio performance history table';

-- Sample data insertion

-- Portfolio data
INSERT INTO portfolio (name, description) VALUES 
('Steady Growth Portfolio', 'Conservative portfolio focused on blue-chip stocks and bonds'),
('Technology Pioneer Portfolio', 'Growth stock portfolio focused on tech industry'),
('Global Balanced Allocation', 'Diversified multi-market, multi-asset portfolio'),
('Fixed Income Portfolio', 'Bond and fixed income focused portfolio'),
('High Growth Portfolio', 'Portfolio targeting emerging markets and high-growth companies');



-- Portfolio performance data
-- (Original data remains unchanged as it doesn't contain Chinese)
-- [Performance data insertion code remains unchanged]

-- Create User Table
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'User unique identifier ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Username for login and display',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT 'User email (unique)',
    initial_amount DECIMAL(15, 2) NOT NULL DEFAULT 0.00 COMMENT 'Initial deposit amount',
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0) COMMENT 'Current account balance (must be ≥0)',
    currency VARCHAR(3) DEFAULT 'USD' COMMENT 'Currency type (e.g. USD, CNY)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation time',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time'
) COMMENT='User account information table';

INSERT INTO user (username, email, initial_amount, balance)
VALUES ('john_doe', 'john.doe@example.com', 10000.00, 10000.00);

-- Market Table
CREATE TABLE IF NOT EXISTS market (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Market ID, primary key, auto-increment',
    type ENUM('STOCK','BOND','ETF','CASH','OTHER') NOT NULL COMMENT 'Type: stock/bond/ETF/cash/other',
    symbol VARCHAR(20) NOT NULL COMMENT 'Symbol (e.g., AAPL stock symbol)',
    name VARCHAR(100) COMMENT 'Name',
    current_price DECIMAL(18,4) COMMENT 'Current market price',
    currency VARCHAR(3) DEFAULT 'USD' COMMENT 'Currency type, default USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    INDEX idx_symbol (symbol) COMMENT 'Symbol index'
) COMMENT 'Market details table';

-- Transaction Record Table
CREATE TABLE `transaction_record`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Record ID, primary key, auto-increment',
  `portfolio_id` int(11) NOT NULL COMMENT 'Owning portfolio ID, logical link to portfolio table',
  `type` enum('BUY','SELL','DIVIDEND','TRANSFER_IN','TRANSFER_OUT') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Transaction type: buy/sell/dividend/transfer_in/transfer_out',
  `asset_type` enum('STOCK','BOND','ETF','CASH','OTHER') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Asset type, matches asset table',
  `symbol` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'Asset symbol (e.g., AAPL stock symbol)',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Asset name',
  `quantity` decimal(18, 2) NOT NULL COMMENT 'Transaction quantity (positive for both buy/sell)',
  `price` decimal(18, 2) NOT NULL COMMENT 'Unit price',
  `amount` decimal(18, 2) GENERATED ALWAYS AS ((`quantity` * `price`)) STORED COMMENT 'Total transaction amount, auto-generated' NULL,
  `currency` varchar(3) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'USD' COMMENT 'Currency, default USD',
  `trade_date` date NOT NULL COMMENT 'Trade date',
  `note` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Notes (commissions, dividend explanations, etc.)',
  `created_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT 'Creation time',
  `updated_at` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT 'Update time',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_portfolio`(`portfolio_id`) USING BTREE,
  INDEX `idx_symbol`(`symbol`) USING BTREE,
  INDEX `idx_trade_date`(`trade_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Asset transaction records table' ROW_FORMAT = Dynamic;

