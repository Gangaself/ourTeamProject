import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import portfolioRoutes from './routes/portfolioRoutes.js';
import assetRoutes from './routes/assetRoutes.js';
import marketRoutes from './routes/marketRoutes.js';
import performanceRoutes from './routes/performanceRoutes.js';



import path from 'path';
import { fileURLToPath } from 'url';

const app = express();
const __dirname = path.dirname(fileURLToPath(import.meta.url));

app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/api/portfolio', portfolioRoutes);
app.use('/api/assets', assetRoutes);
app.use('/api/markets', marketRoutes);
app.use('/api/portfolio-performance',performanceRoutes);


const PORT = 3000;
app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));
