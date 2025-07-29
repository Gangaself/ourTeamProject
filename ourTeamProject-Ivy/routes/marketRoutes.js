import { Router } from 'express';
const router = Router();
import {addMarket,deleteMarket } from '../services/marketService.js';
import connection from '../config/db.js';

router.get('/all', async (req, res) => {
  try {
    let query = 'SELECT * FROM market';
    const params = [];
    const conditions = [];

    if (req.query.symbol) {
      conditions.push('symbol = ?');
      params.push(req.query.symbol);
    }

    if (req.query.name) {
      conditions.push('(name LIKE ? )');
      params.push(`%${req.query.name}%`);
    }

    if (req.query.type) {
      conditions.push('type = ?');
      params.push(req.query.type);
    }

    if (conditions.length > 0) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    const [rows] = await connection.execute(query, params);
    res.json(rows);
  } catch (error) {
    console.error('查询市场数据失败:', error);
    res.status(500).json({ error: '获取市场数据失败' });
  }
});

router.post('/', async (req, res) => {
  try {
    console.log(req.body);
    const market = await addMarket(req.body);
    res.json(market);
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


export default router;
