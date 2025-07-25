import express from 'express';
import { listPortfolios, addPortfolio, removePortfolio } from '../controllers/portfolioController.js';

const router = express.Router();

router.get('/', listPortfolios);
router.post('/', addPortfolio);
router.delete('/:id', removePortfolio);

export default router;
