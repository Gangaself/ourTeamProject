const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'n3u3da!',
  database: 'portfolio-manager',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// 初始化数据库表
const initDB = async () => {
  try {
    const connection = await pool.getConnection();
    
    // 创建持仓表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS holdings (
        id INT AUTO_INCREMENT PRIMARY KEY,
        symbol VARCHAR(10) NOT NULL,
        name VARCHAR(100),
        quantity DECIMAL(20, 4) NOT NULL,
        purchase_price DECIMAL(20, 4) NOT NULL,
        current_price DECIMAL(20, 4),
        account_type ENUM('Cash', 'Brokerage', '401k', 'IRA', 'Taxable', 'Pension', 'Savings', 'Checking') NOT NULL,
        account_name VARCHAR(100),
        category ENUM('US Stocks', 'International Stocks', 'Bonds', 'Cash', 'Real Estate', 'Commodities', 'Other') NOT NULL,
        fees DECIMAL(20, 4) DEFAULT 0,
        purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP,
        last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    // 创建市场数据表
    await connection.query(`
      CREATE TABLE IF NOT EXISTS market_data (
        id INT AUTO_INCREMENT PRIMARY KEY,
        symbol VARCHAR(10) NOT NULL UNIQUE,
        name VARCHAR(100) NOT NULL,
        price DECIMAL(20, 4) NOT NULL,
        change DECIMAL(20, 4) NOT NULL,
        change_percent DECIMAL(20, 4) NOT NULL,
        sector VARCHAR(50),
        exchange VARCHAR(50),
        currency VARCHAR(10),
        last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      )
    `);
    
    connection.release();
    console.log('MySQL tables initialized');
  } catch (err) {
    console.error('Error initializing MySQL tables:', err);
    throw err;
  }
};

module.exports = { pool, initDB };