import connection from '../config/db.js';

export async function addAsset(data) {
  const {
    portfolio_id, type, symbol, name, quantity,
    purchase_price, current_price, purchase_date
  } = data;


  const [result] = await connection.query(
    `INSERT INTO asset (portfolio_id, type, symbol, name, quantity, purchase_price, current_price, purchase_date)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      Number(portfolio_id),
      type,
      symbol,
      name,
      toNullableNumber(quantity),
      toNullableNumber(purchase_price),
      toNullableNumber(current_price),
      purchase_date
    ]
  );

  return { id: result.insertId, ...data };
}
function toNullableNumber(val) {
  return val === '' || val === null || val === undefined ? null : Number(val);
}


export async function getAssetsByPortfolioId(req, res) {
  const portfolioId = req.query.portfolio_id;
  if (!portfolioId) {
    return res.status(400).json({ error: '缺少 portfolio_id 参数' });
  }

  try {
    const [rows] = await connection.query(
      'SELECT * FROM asset WHERE portfolio_id = ?',
      [portfolioId]
    );
    res.json(rows);
  } catch (err) {
    console.error('获取资产失败:', err);
    res.status(500).json({ error: '服务器内部错误' });
  }
}


export async function deleteAsset(id) {
  await connection.query(`DELETE FROM asset WHERE id = ?`, [id]);
}

export async function sellAsset(data) {
  const { assetId, quantity, price, date, note } = data;

  try {
    // 获取资产详情
    const [assetRows] = await connection.query('SELECT * FROM asset WHERE id = ?', [assetId]);
    if (assetRows.length === 0) throw new Error('资产未找到');

    const asset = assetRows[0];

    // 插入交易记录
    await connection.query(
      `INSERT INTO transaction_record 
          (portfolio_id, type, asset_type, symbol, name, quantity, price, currency, trade_date, note)
          VALUES (?, 'SELL', ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        asset.portfolio_id,
        asset.type,
        asset.symbol,
        asset.name,
        quantity,
        price,
        asset.currency,
        date,
        note || `卖出${asset.symbol}`
      ]
    );

    // 删除资产记录
    await connection.query('DELETE FROM asset WHERE id = ?', [assetId]);

    return true;
  } catch (error) {
    console.error('卖出资产失败:', error);
    throw error;
  }
}


