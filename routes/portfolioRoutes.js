import express from 'express';
import { listPortfolios, addPortfolio, removePortfolio, upPortfolio} from '../controllers/portfolioController.js';

const router = express.Router();

router.get('/', listPortfolios);
router.post('/', addPortfolio);
router.delete('/:id', removePortfolio);
router.put('/:id', upPortfolio);

export default router;
