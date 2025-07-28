import { Router } from 'express';
const router = Router();
import { addAsset, deleteAsset,getAssetsByPortfolioId } from '../services/assetService.js';

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

export default router;
