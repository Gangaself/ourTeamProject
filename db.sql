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