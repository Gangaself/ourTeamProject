const { pool } = require('../config/db');

class Holding {
  static async findAll() {
    const [rows] = await pool.query('SELECT * FROM holdings');
    return rows;
  }

  static async findById(id) {
    const [rows] = await pool.query('SELECT * FROM holdings WHERE id = ?', [id]);
    return rows[0];
  }

  static async create({
    symbol,
    name,
    quantity,
    purchasePrice,
    currentPrice,
    accountType,
    accountName,
    category,
    fees
  }) {
    const [result] = await pool.query(
      `INSERT INTO holdings 
      (symbol, name, quantity, purchase_price, current_price, account_type, account_name, category, fees)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [symbol, name, quantity, purchasePrice, currentPrice, accountType, accountName, category, fees]
    );
    return this.findById(result.insertId);
  }

  static async update(id, updateData) {
    const fields = [];
    const values = [];
    
    // 转换驼峰命名到数据库列名
    const columnMap = {
      currentPrice: 'current_price',
      purchasePrice: 'purchase_price',
      accountType: 'account_type',
      accountName: 'account_name'
    };
    
    for (const [key, value] of Object.entries(updateData)) {
      if (value !== undefined) {
        const columnName = columnMap[key] || key;
        fields.push(`${columnName} = ?`);
        values.push(value);
      }
    }
    
    if (fields.length === 0) {
      return this.findById(id);
    }
    
    values.push(id);
    
    await pool.query(
      `UPDATE holdings SET ${fields.join(', ')} WHERE id = ?`,
      values
    );
    
    return this.findById(id);
  }

  static async delete(id) {
    await pool.query('DELETE FROM holdings WHERE id = ?', [id]);
  }

  static async updatePrices(updates) {
    const updatePromises = updates.map(({ id, currentPrice }) => {
      return pool.query(
        'UPDATE holdings SET current_price = ? WHERE id = ?',
        [currentPrice, id]
      );
    });
    
    await Promise.all(updatePromises);
    return updates.map(update => ({ id: update.id, success: true }));
  }
}

module.exports = Holding;