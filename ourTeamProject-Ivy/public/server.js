import express from 'express';
import connection from '../config/db.js'; // 导入数据库连接对象

const app = express();
const port = 3000;

// 允许跨域请求
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// 获取所有资产数据
app.get('/api/assets', async (req, res) => {
  try {
    // 构建查询条件
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
    
    // 直接使用导入的connection对象执行查询
    const [rows] = await connection.execute(query, params);
    res.json(rows);
  } catch (error) {
    console.error('查询资产数据失败:', error);
    res.status(500).json({ error: '获取资产数据失败' });
  }
});

app.listen(port, () => {
  console.log(`API服务运行在 http://localhost:${port}`);
});