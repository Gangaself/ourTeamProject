import db from '../config/db.js';


const searchTransactions = async ({ asset_type, symbol, name, start_date, end_date }) => {
  let sql = 'SELECT * FROM transaction_record WHERE 1=1';
  const values = [];

  if (asset_type) {
    sql += ' AND asset_type = ?';
    values.push(asset_type);
  }

  if (symbol) {
    sql += ' AND symbol = ?';
    values.push(symbol);
  }

  if (name) {
    sql += ' AND name LIKE ?';
    values.push(`%${name}%`);
  }

  if (start_date && end_date) {
    sql += ' AND trade_date BETWEEN ? AND ?';
    values.push(start_date, end_date);
  } else if (start_date) {
    sql += ' AND trade_date >= ?';
    values.push(start_date);
  } else if (end_date) {
    sql += ' AND trade_date <= ?';
    values.push(end_date);
  }

  sql += ' ORDER BY trade_date DESC';

  try {
    const [rows] = await db.query(sql, values);
    return rows;
  } catch (error) {
    console.error('Database query error:', error);
    throw new Error('查询交易记录失败，请重试');
  }
};


const getAllTransactions = async () => {
  const [rows] = await db.query('SELECT * FROM transaction_record ORDER BY transaction_date DESC');
  return rows;
};

const createTransaction = async (data) => {
  const { portfolio_id, type, asset_type, symbol, name, quantity, price, currency, trade_date, note } = data;

  const [result] = await db.query(
    `INSERT INTO transaction_record 
      (portfolio_id, type, asset_type, symbol, name, quantity, price, currency, trade_date, note)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    [portfolio_id, type, asset_type, symbol, name, quantity, price, currency, trade_date, note || null]
  );

  return result;
};

const deleteTransaction = async (id) => {
  await db.query('DELETE FROM transaction_record WHERE id = ?', [id]);
};

export { getAllTransactions, createTransaction, deleteTransaction, searchTransactions };
