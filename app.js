import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import portfolioRoutes from './routes/portfolioRoutes.js';
import assetRoutes from './routes/assetRoutes.js';
import performanceRoutes from './routes/performanceRoutes.js';
import marketRoutes from './routes/marketRoutes.js';
import path from 'path';
import { fileURLToPath } from 'url';

import userRoutes from './routes/userRoutes.js';


const app = express();
const __dirname = path.dirname(fileURLToPath(import.meta.url));

app.use(cors());
app.use(bodyParser.json());
// 设置静态文件目录（包含HTML、CSS、JS等）
app.use(express.static(path.join(__dirname, 'public')));
app.use('/css', express.static(path.join(__dirname, 'public/css')));
app.use('/js', express.static(path.join(__dirname, 'public/js')));

app.use('/api/portfolio', portfolioRoutes);
app.use('/api/assets', assetRoutes);
app.use('/api/portfolio-performance', performanceRoutes);
app.use('/api/markets', marketRoutes);

app.use('/api/user', userRoutes);

// 所有路由都返回index.html (支持前端路由)
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
  });

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
