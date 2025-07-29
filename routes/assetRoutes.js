import { Router } from 'express';
const router = Router();
import { addAsset, deleteAsset,getAssetsByPortfolioId } from '../services/assetService.js';
import connection from '../config/db.js';
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

// 获取所有资产数据
router.get('/all', async (req, res) => {         
  try {
    let query = 'SELECT * FROM asset';
    const params = [];
    const conditions = [];

    if (req.query.id) {
      conditions.push('id = ?');
      params.push(req.query.id);
    }

    if (req.query.name) {
      conditions.push('(name LIKE ? OR symbol LIKE ?)');
      params.push(`%${req.query.name}%`, `%${req.query.name}%`);
    }

    if (req.query.type) {
      conditions.push('type = ?');
      params.push(req.query.type);
    }

    if (req.query.portfolio) {
      conditions.push('portfolio_id = ?');
      params.push(req.query.portfolio);
    }

    if (req.query.date) {
      conditions.push('purchase_date = ?');
      params.push(req.query.date);
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

export default router;
