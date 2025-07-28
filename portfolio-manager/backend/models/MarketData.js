const { pool } = require('../config/db');

class MarketData {
  static async findAll() {
    const [rows] = await pool.query('SELECT * FROM market_data');
    return rows;
  }

  static async findBySymbol(symbol) {
    const [rows] = await pool.query('SELECT * FROM market_data WHERE symbol = ?', [symbol]);
    return rows[0];
  }

  static async updateOrCreate({
    symbol,
    name,
    price,
    change,
    changePercent,
    sector,
    exchange,
    currency
  }) {
    await pool.query(
      `INSERT INTO market_data 
      (symbol, name1, price, change1, change_percent, sector, exchange, currency)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
      name = VALUES(name1),
      price = VALUES(price),
      change = VALUES(change1),
      change_percent = VALUES(change_percent),
      sector = VALUES(sector),
      exchange = VALUES(exchange),
      currency = VALUES(currency)`,
      [symbol, name, price, change, changePercent, sector, exchange, currency]
    );
    return this.findBySymbol(symbol);
  }

  static async getIndices() {
    const [rows] = await pool.query(`
      SELECT * FROM market_data 
      WHERE symbol IN ('^GSPC', '^DJI', '^IXIC')
    `);
    return rows;
  }
}

module.exports = MarketData;