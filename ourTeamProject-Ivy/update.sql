-- 清空表数据（仅用于测试环境）
TRUNCATE TABLE market;
TRUNCATE TABLE portfolio;
TRUNCATE TABLE asset;
TRUNCATE TABLE transaction_record;
TRUNCATE TABLE portfolio_performance;

-- 插入市场数据
INSERT INTO market (type, symbol, name, current_price, currency) VALUES
-- 股票
('STOCK', 'AAPL', 'Apple Inc.', 215.32, 'USD'),
('STOCK', 'MSFT', 'Microsoft Corporation', 420.75, 'USD'),
('STOCK', 'GOOGL', 'Alphabet Inc.', 182.50, 'USD'),
('STOCK', 'AMZN', 'Amazon.com Inc.', 185.90, 'USD'),
('STOCK', 'TSLA', 'Tesla Inc.', 250.45, 'USD'),
('STOCK', 'NVDA', 'NVIDIA Corporation', 125.80, 'USD'),
('STOCK', 'META', 'Meta Platforms Inc.', 310.20, 'USD'),
('STOCK', 'JPM', 'JPMorgan Chase & Co.', 195.75, 'USD'),
('STOCK', 'V', 'Visa Inc.', 280.30, 'USD'),
('STOCK', 'WMT', 'Walmart Inc.', 70.45, 'USD'),

-- 债券
('BOND', 'US10Y', '10-Year Treasury Note', 98.75, 'USD'),
('BOND', 'US30Y', '30-Year Treasury Bond', 95.20, 'USD'),
('BOND', 'CORP001', 'Corporate Bond A', 102.30, 'USD'),
('BOND', 'CORP002', 'Corporate Bond B', 101.75, 'USD'),
('BOND', 'MUNI001', 'Municipal Bond X', 99.50, 'USD'),

-- ETF
('ETF', 'SPY', 'SPDR S&P 500 ETF', 525.80, 'USD'),
('ETF', 'QQQ', 'Invesco QQQ Trust', 450.25, 'USD'),
('ETF', 'IWM', 'iShares Russell 2000 ETF', 210.75, 'USD'),
('ETF', 'GLD', 'SPDR Gold Shares', 185.30, 'USD'),
('ETF', 'BND', 'Vanguard Total Bond Market ETF', 75.40, 'USD'),

-- 现金
('CASH', 'USD', 'US Dollar', 1.0000, 'USD'),
('CASH', 'EUR', 'Euro', 1.1200, 'USD'),
('CASH', 'JPY', 'Japanese Yen', 0.0090, 'USD'),
('CASH', 'GBP', 'British Pound', 1.3100, 'USD'),

-- 其他
('OTHER', 'BTC', 'Bitcoin', 65000.00, 'USD'),
('OTHER', 'ETH', 'Ethereum', 3500.00, 'USD'),
('OTHER', 'REIT001', 'Real Estate Investment Trust A', 45.75, 'USD');


-- 插入投资组合数据
INSERT INTO portfolio (name, description) VALUES
('Conservative Portfolio', 'Primarily bonds and cash, suitable for investors with low risk tolerance'),
('Balanced Portfolio', 'Balanced allocation between stocks and bonds, suitable for investors with moderate risk tolerance'),
('Growth Portfolio', 'Primarily stocks, suitable for investors seeking long-term capital appreciation'),
('Technology Themed Portfolio', 'Portfolio focused on the technology sector'),
('Globally Diversified Portfolio', 'Diversified portfolio containing various global assets');

-- ----------------------------
-- Records of transaction_record
INSERT INTO `transaction_record` VALUES (1, 1, 'BUY', 'STOCK', 'JNJ', 'Johnson & Johnson', 50.00, 165.30, DEFAULT, 'USD', '2023-01-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (2, 1, 'BUY', 'BOND', 'US10Y', 'US 10-Year Treasury Bond', 1000.00, 98.50, DEFAULT, 'USD', '2023-02-20', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (3, 1, 'BUY', 'CASH', 'USD', 'US Dollar Cash', 50000.00, 1.00, DEFAULT, 'USD', '2023-03-01', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (4, 2, 'BUY', 'STOCK', 'AAPL', 'Apple Inc.', 30.00, 145.80, DEFAULT, 'USD', '2023-01-10', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (5, 2, 'BUY', 'STOCK', 'MSFT', 'Microsoft Corporation', 20.00, 245.60, DEFAULT, 'USD', '2023-02-05', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (6, 2, 'BUY', 'STOCK', 'GOOGL', 'Alphabet Inc. Class A', 15.00, 102.75, DEFAULT, 'USD', '2023-03-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (7, 3, 'BUY', 'ETF', 'VTI', 'Vanguard Total Stock Market ETF', 45.00, 215.40, DEFAULT, 'USD', '2023-01-20', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (8, 3, 'BUY', 'ETF', 'BND', 'Vanguard Total Bond Market ETF', 800.00, 79.85, DEFAULT, 'USD', '2023-02-10', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (9, 3, 'BUY', 'ETF', 'VXUS', 'Vanguard Total International Stock ETF', 60.00, 55.30, DEFAULT, 'USD', '2023-03-05', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (10, 4, 'BUY', 'BOND', 'CORP', 'Corporate Bond', 5000.00, 100.00, DEFAULT, 'USD', '2023-01-25', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (11, 4, 'BUY', 'BOND', 'MUNI', 'Municipal Bond', 3000.00, 100.00, DEFAULT, 'USD', '2023-02-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (12, 4, 'BUY', 'CASH', 'USD', 'US Dollar Cash', 20000.00, 1.00, DEFAULT, 'USD', '2023-03-10', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (13, 5, 'BUY', 'STOCK', 'TSLA', 'Tesla Inc.', 10.00, 180.50, DEFAULT, 'USD', '2023-01-05', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (14, 5, 'BUY', 'STOCK', 'NVDA', 'NVIDIA Corporation', 25.00, 220.40, DEFAULT, 'USD', '2023-02-25', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (15, 5, 'BUY', 'ETF', 'ARKK', 'ARK Innovation ETF', 100.00, 45.60, DEFAULT, 'USD', '2023-03-20', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (16, 2, 'SELL', 'STOCK', 'AAPL', 'Apple Inc.', 10.00, 172.00, DEFAULT, 'USD', '2024-05-01', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (17, 2, 'SELL', 'STOCK', 'GOOGL', 'Alphabet Inc. Class A', 5.00, 120.00, DEFAULT, 'USD', '2024-06-15', NULL, '2025-07-29 16:52:31', '2025-07-29 16:52:31');
INSERT INTO `transaction_record` VALUES (18, 3, 'SELL', 'ETF', 'VTI', 'Vanguard Total Stock Market ETF', 20.00, 230.00, DEFAULT, 'USD', '2025-07-16', NULL, '2025-07-29 16:52:31', '2025-07-30 11:07:01');
INSERT INTO `transaction_record` VALUES (19, 5, 'SELL', 'STOCK', 'TSLA', 'Tesla Inc.', 5.00, 220.00, DEFAULT, 'USD', '2025-07-11', NULL, '2025-07-29 16:52:31', '2025-07-30 11:06:44');
INSERT INTO `transaction_record` VALUES (20, 5, 'SELL', 'ETF', 'ARKK', 'ARK Innovation ETF', 40.00, 55.00, DEFAULT, 'USD', '2025-07-01', NULL, '2025-07-29 16:52:31', '2025-07-30 11:06:50');




-- 插入资产数据（基于交易记录和当前市场价格）


-- 1. 保守型投资组合
INSERT INTO asset (portfolio_id, type, symbol, name, quantity, purchase_price, current_price, purchase_date, currency) VALUES
(1, 'BOND', 'US10Y', '10-Year Treasury Note', 100, 98.50, 98.75, '2025-07-01', 'USD'), -- 小幅盈利
(1, 'BOND', 'US30Y', '30-Year Treasury Bond', 50, 95.00, 94.80, '2025-07-01', 'USD'), -- 小幅亏损
(1, 'BOND', 'CORP001', 'Corporate Bond A', 75, 102.00, 101.50, '2025-07-05', 'USD'), -- 小幅亏损
(1, 'CASH', 'USD', 'US Dollar', 5000, 1.0000, 1.0000, '2025-07-10', 'USD'), -- 持平
(1, 'ETF', 'BND', 'Vanguard Total Bond Market ETF', 200, 75.20, 74.90, '2025-07-15', 'USD'); -- 小幅亏损

-- 2. 平衡型投资组合
INSERT INTO asset (portfolio_id, type, symbol, name, quantity, purchase_price, current_price, purchase_date, currency) VALUES
(2, 'STOCK', 'AAPL', 'Apple Inc.', 40, 210.00, 215.32, '2025-07-02', 'USD'), -- 盈利
(2, 'STOCK', 'JPM', 'JPMorgan Chase & Co.', 40, 190.00, 185.50, '2025-07-02', 'USD'), -- 亏损
(2, 'BOND', 'US10Y', '10-Year Treasury Note', 50, 98.60, 98.75, '2025-07-03', 'USD'), -- 小幅盈利
(2, 'ETF', 'SPY', 'SPDR S&P 500 ETF', 30, 520.00, 515.20, '2025-07-08', 'USD'), -- 亏损
(2, 'ETF', 'BND', 'Vanguard Total Bond Market ETF', 100, 75.10, 75.40, '2025-07-10', 'USD'); -- 小幅盈利

-- 3. 成长型投资组合
INSERT INTO asset (portfolio_id, type, symbol, name, quantity, purchase_price, current_price, purchase_date, currency) VALUES
(3, 'STOCK', 'TSLA', 'Tesla Inc.', 25, 245.00, 240.75, '2025-07-01', 'USD'), -- 亏损
(3, 'STOCK', 'NVDA', 'NVIDIA Corporation', 40, 120.00, 125.80, '2025-07-01', 'USD'), -- 盈利
(3, 'STOCK', 'META', 'Meta Platforms Inc.', 25, 305.00, 300.50, '2025-07-05', 'USD'), -- 亏损
(3, 'ETF', 'QQQ', 'Invesco QQQ Trust', 50, 445.00, 450.25, '2025-07-10', 'USD'), -- 盈利
(3, 'OTHER', 'BTC', 'Bitcoin', 0.5, 64000.00, 62000.00, '2025-07-15', 'USD'), -- 亏损
(3, 'STOCK', 'AMZN', 'Amazon.com Inc.', 20, 180.00, 185.90, '2025-07-20', 'USD'); -- 盈利

-- 4. 科技主题投资组合
INSERT INTO asset (portfolio_id, type, symbol, name, quantity, purchase_price, current_price, purchase_date, currency) VALUES
(4, 'STOCK', 'AAPL', 'Apple Inc.', 40, 212.00, 215.32, '2025-07-03', 'USD'), -- 盈利
(4, 'STOCK', 'MSFT', 'Microsoft Corporation', 30, 415.00, 410.25, '2025-07-03', 'USD'), -- 亏损
(4, 'STOCK', 'GOOGL', 'Alphabet Inc.', 25, 180.00, 175.50, '2025-07-05', 'USD'), -- 亏损
(4, 'STOCK', 'NVDA', 'NVIDIA Corporation', 50, 122.00, 125.80, '2025-07-10', 'USD'), -- 盈利
(4, 'ETF', 'QQQ', 'Invesco QQQ Trust', 40, 448.00, 450.25, '2025-07-15', 'USD'), -- 小幅盈利
(4, 'STOCK', 'META', 'Meta Platforms Inc.', 20, 308.00, 310.20, '2025-07-20', 'USD'); -- 小幅盈利

-- 5. 全球多元化投资组合
INSERT INTO asset (portfolio_id, type, symbol, name, quantity, purchase_price, current_price, purchase_date, currency) VALUES
(5, 'STOCK', 'AAPL', 'Apple Inc.', 30, 213.00, 215.32, '2025-07-01', 'USD'), -- 盈利
(5, 'ETF', 'SPY', 'SPDR S&P 500 ETF', 20, 523.00, 525.80, '2025-07-01', 'USD'), -- 盈利
(5, 'CASH', 'EUR', 'Euro', 2000, 1.1150, 1.1100, '2025-07-05', 'USD'), -- 亏损
(5, 'CASH', 'JPY', 'Japanese Yen', 50000, 0.0089, 0.0090, '2025-07-05', 'USD'), -- 盈利
(5, 'ETF', 'GLD', 'SPDR Gold Shares', 50, 184.00, 183.50, '2025-07-10', 'USD'), -- 小幅亏损
(5, 'BOND', 'US10Y', '10-Year Treasury Note', 40, 98.70, 98.75, '2025-07-15', 'USD'), -- 小幅盈利
(5, 'OTHER', 'REIT001', 'Real Estate Investment Trust A', 100, 45.50, 44.80, '2025-07-20', 'USD'); -- 亏损


-- 为每个投资组合插入7月的表现数据
-- 保守型投资组合 (portfolio_id = 1)
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return) VALUES
(1, '2025-07-01', 24500.00, NULL),
(1, '2025-07-02', 24550.00, 0.0020),
(1, '2025-07-03', 24600.00, 0.0020),
(1, '2025-07-04', 24620.00, 0.0008),
(1, '2025-07-05', 32000.00, 0.2996),
(1, '2025-07-06', 32020.00, 0.0006),
(1, '2025-07-07', 32050.00, 0.0009),
(1, '2025-07-08', 32080.00, 0.0009),
(1, '2025-07-09', 32100.00, 0.0006),
(1, '2025-07-10', 37100.00, 0.1558),
(1, '2025-07-11', 37150.00, 0.0013),
(1, '2025-07-12', 37180.00, 0.0008),
(1, '2025-07-13', 37200.00, 0.0005),
(1, '2025-07-14', 37220.00, 0.0005),
(1, '2025-07-15', 42200.00, 0.1338),
(1, '2025-07-16', 42250.00, 0.0012),
(1, '2025-07-17', 42280.00, 0.0007),
(1, '2025-07-18', 42300.00, 0.0005),
(1, '2025-07-19', 42320.00, 0.0005),
(1, '2025-07-20', 42350.00, 0.0007),
(1, '2025-07-21', 42380.00, 0.0007),
(1, '2025-07-22', 42400.00, 0.0005),
(1, '2025-07-23', 42420.00, 0.0005),
(1, '2025-07-24', 42450.00, 0.0007),
(1, '2025-07-25', 42480.00, 0.0007),
(1, '2025-07-26', 42500.00, 0.0005),
(1, '2025-07-27', 42520.00, 0.0005),
(1, '2025-07-28', 42550.00, 0.0007),
(1, '2025-07-29', 42580.00, 0.0007),
(1, '2025-07-30', 42600.00, 0.0005);

-- 平衡型投资组合 (portfolio_id = 2)
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return) VALUES
(2, '2025-07-01', 20000.00, NULL),
(2, '2025-07-02', 30000.00, 0.5000),
(2, '2025-07-03', 35000.00, 0.1667),
(2, '2025-07-04', 35100.00, 0.0029),
(2, '2025-07-05', 35200.00, 0.0028),
(2, '2025-07-06', 35300.00, 0.0028),
(2, '2025-07-07', 35400.00, 0.0028),
(2, '2025-07-08', 40000.00, 0.1299),
(2, '2025-07-09', 40100.00, 0.0025),
(2, '2025-07-10', 45000.00, 0.1222),
(2, '2025-07-11', 45100.00, 0.0022),
(2, '2025-07-12', 45200.00, 0.0022),
(2, '2025-07-13', 45300.00, 0.0022),
(2, '2025-07-14', 45400.00, 0.0022),
(2, '2025-07-15', 45500.00, 0.0022),
(2, '2025-07-16', 45600.00, 0.0022),
(2, '2025-07-17', 45700.00, 0.0022),
(2, '2025-07-18', 44000.00, -0.0372),
(2, '2025-07-19', 44100.00, 0.0023),
(2, '2025-07-20', 44200.00, 0.0023),
(2, '2025-07-21', 44300.00, 0.0023),
(2, '2025-07-22', 44400.00, 0.0023),
(2, '2025-07-23', 44500.00, 0.0023),
(2, '2025-07-24', 44600.00, 0.0022),
(2, '2025-07-25', 44750.00, 0.0034),
(2, '2025-07-26', 44800.00, 0.0011),
(2, '2025-07-27', 44900.00, 0.0022),
(2, '2025-07-28', 45000.00, 0.0022),
(2, '2025-07-29', 45100.00, 0.0022),
(2, '2025-07-30', 45200.00, 0.0022);

-- 成长型投资组合 (portfolio_id = 3)
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return) VALUES
(3, '2025-07-01', 30000.00, NULL),
(3, '2025-07-02', 30100.00, 0.0033),
(3, '2025-07-03', 30200.00, 0.0033),
(3, '2025-07-04', 30300.00, 0.0033),
(3, '2025-07-05', 35000.00, 0.1551),
(3, '2025-07-06', 35100.00, 0.0029),
(3, '2025-07-07', 35200.00, 0.0028),
(3, '2025-07-08', 35300.00, 0.0028),
(3, '2025-07-09', 35400.00, 0.0028),
(3, '2025-07-10', 50000.00, 0.4124),
(3, '2025-07-11', 50200.00, 0.0040),
(3, '2025-07-12', 50400.00, 0.0040),
(3, '2025-07-13', 50600.00, 0.0040),
(3, '2025-07-14', 50800.00, 0.0040),
(3, '2025-07-15', 55000.00, 0.0827),
(3, '2025-07-16', 55200.00, 0.0036),
(3, '2025-07-17', 55400.00, 0.0036),
(3, '2025-07-18', 55600.00, 0.0036),
(3, '2025-07-19', 55800.00, 0.0036),
(3, '2025-07-20', 60000.00, 0.0753),
(3, '2025-07-21', 60200.00, 0.0033),
(3, '2025-07-22', 59000.00, -0.0199),
(3, '2025-07-23', 59200.00, 0.0034),
(3, '2025-07-24', 59400.00, 0.0034),
(3, '2025-07-25', 59600.00, 0.0034),
(3, '2025-07-26', 59800.00, 0.0034),
(3, '2025-07-27', 60000.00, 0.0033),
(3, '2025-07-28', 60200.00, 0.0033),
(3, '2025-07-29', 60400.00, 0.0033),
(3, '2025-07-30', 60600.00, 0.0033);

-- 科技主题投资组合 (portfolio_id = 4)
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return) VALUES
(4, '2025-07-01', 25000.00, NULL),
(4, '2025-07-02', 25100.00, 0.0040),
(4, '2025-07-03', 35000.00, 0.3944),
(4, '2025-07-04', 35100.00, 0.0029),
(4, '2025-07-05', 40000.00, 0.1396),
(4, '2025-07-06', 40200.00, 0.0050),
(4, '2025-07-07', 40400.00, 0.0050),
(4, '2025-07-08', 40600.00, 0.0050),
(4, '2025-07-09', 40800.00, 0.0049),
(4, '2025-07-10', 50000.00, 0.2255),
(4, '2025-07-11', 50200.00, 0.0040),
(4, '2025-07-12', 50400.00, 0.0040),
(4, '2025-07-13', 50600.00, 0.0040),
(4, '2025-07-14', 50800.00, 0.0040),
(4, '2025-07-15', 60000.00, 0.1811),
(4, '2025-07-16', 60200.00, 0.0033),
(4, '2025-07-17', 60400.00, 0.0033),
(4, '2025-07-18', 60600.00, 0.0033),
(4, '2025-07-19', 60800.00, 0.0033),
(4, '2025-07-20', 65000.00, 0.0691),
(4, '2025-07-21', 65200.00, 0.0031),
(4, '2025-07-22', 65400.00, 0.0031),
(4, '2025-07-23', 65600.00, 0.0031),
(4, '2025-07-24', 65800.00, 0.0030),
(4, '2025-07-25', 66000.00, 0.0030),
(4, '2025-07-26', 66200.00, 0.0030),
(4, '2025-07-27', 66400.00, 0.0030),
(4, '2025-07-28', 66600.00, 0.0030),
(4, '2025-07-29', 66800.00, 0.0030),
(4, '2025-07-30', 67000.00, 0.0030);

-- 全球多元化投资组合 (portfolio_id = 5)
INSERT INTO portfolio_performance (portfolio_id, record_date, total_value, daily_return) VALUES
(5, '2025-07-01', 30000.00, NULL),
(5, '2025-07-02', 30100.00, 0.0033),
(5, '2025-07-03', 30200.00, 0.0033),
(5, '2025-07-04', 30300.00, 0.0033),
(5, '2025-07-05', 35000.00, 0.1551),
(5, '2025-07-06', 35100.00, 0.0029),
(5, '2025-07-07', 35200.00, 0.0028),
(5, '2025-07-08', 35300.00, 0.0028),
(5, '2025-07-09', 35400.00, 0.0028),
(5, '2025-07-10', 40000.00, 0.1299),
(5, '2025-07-11', 40100.00, 0.0025),
(5, '2025-07-12', 40200.00, 0.0025),
(5, '2025-07-13', 40300.00, 0.0025),
(5, '2025-07-14', 40400.00, 0.0025),
(5, '2025-07-15', 45000.00, 0.1139),
(5, '2025-07-16', 45100.00, 0.0022),
(5, '2025-07-17', 45200.00, 0.0022),
(5, '2025-07-18', 45300.00, 0.0022),
(5, '2025-07-19', 45400.00, 0.0022),
(5, '2025-07-20', 50000.00, 0.1013),
(5, '2025-07-21', 50100.00, 0.0020),
(5, '2025-07-22', 50200.00, 0.0020),
(5, '2025-07-23', 50300.00, 0.0020),
(5, '2025-07-24', 50400.00, 0.0020),
(5, '2025-07-25', 50500.00, 0.0020),
(5, '2025-07-26', 50600.00, 0.0020),
(5, '2025-07-27', 50700.00, 0.0020),
(5, '2025-07-28', 50800.00, 0.0020),
(5, '2025-07-29', 50900.00, 0.0020),
(5, '2025-07-30', 51000.00, 0.0020);



