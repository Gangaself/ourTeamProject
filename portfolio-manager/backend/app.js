const express = require('express');
const path = require('path');
const cors = require('cors');
const holdingsRoutes = require('./routes/holdings');
const analysisRoutes = require('./routes/analysis');
const marketRoutes = require('./routes/market');

const app = express();

// 中间件
app.use(cors());
app.use(express.json());

// API路由
app.use('/api/holdings', holdingsRoutes);
app.use('/api/analysis', analysisRoutes);
app.use('/api/market', marketRoutes);

// 静态文件服务
app.use(express.static(path.join(__dirname, 'public')));

// 错误处理中间件
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!' });
});

module.exports = app;