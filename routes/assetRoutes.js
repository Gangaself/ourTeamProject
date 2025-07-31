import { Router } from 'express';
const router = Router();
import { addAsset, deleteAsset, getAssetsByPortfolioId } from '../services/assetService.js';
import connection from '../config/db.js';

router.get('/all', async (req, res) => {
  try {
    let query = 'SELECT * FROM asset';
    const params = [];
    const conditions = [];

    if (req.query.name) {
      conditions.push('(name LIKE ? OR symbol LIKE ?)');
      params.push(`%${req.query.name}%`, `%${req.query.name}%`);
    }

    if (req.query.type) {
      conditions.push('type = ?');
      params.push(req.query.type);
    }

    if (req.query.portfolio_id) {
      conditions.push('portfolio_id = ?');
      params.push(req.query.portfolio_id);
    }

    if (req.query.purchase_date) {
      // 将ISO字符串转换为日期部分（YYYY-MM-DD）
      const date = new Date(req.query.purchase_date);
      const formattedDate = date.toISOString().split('T')[0];
      conditions.push('DATE(purchase_date) = ?');
      params.push(formattedDate);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    const [rows] = await connection.execute(query, params);
    res.json(rows);
  } catch (error) {
    console.error('查询资产数据失败:', error);
    res.status(500).json({ error: '获取资产数据失败' });
  }
});
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await connection.execute('SELECT * FROM asset WHERE id = ?', [req.params.id]);
    if (rows.length === 0) {
      return res.status(404).json({ error: '资产未找到' });
    }
    res.json(rows[0]);
  } catch (error) {
    console.error('查询资产详情失败:', error);
    res.status(500).json({ error: '获取资产详情失败' });
  }
});


router.post('/', async (req, res) => {
  try {
    console.log(req.body);
    const asset = await addAsset(req.body);
    res.json(asset);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    await deleteAsset(req.params.id);
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
router.get('/', getAssetsByPortfolioId);

router.post('/sell', async (req, res) => {
  const { assetId, quantity, price, date, note } = req.body;

  try {
    // 1. 获取资产详情
    const [assetRows] = await connection.query('SELECT * FROM asset WHERE id = ?', [assetId]);
    if (assetRows.length === 0) {
      return res.status(404).json({ error: '资产未找到' });
    }

    const asset = assetRows[0];

    // 2. 添加到交易记录表
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

    // 3. 从资产表中删除
    await connection.query('DELETE FROM asset WHERE id = ?', [assetId]);

    res.json({ success: true });
  } catch (error) {
    console.error('卖出资产失败:', error);
    res.status(500).json({ error: '卖出资产失败' });
  }
});

export default router;
