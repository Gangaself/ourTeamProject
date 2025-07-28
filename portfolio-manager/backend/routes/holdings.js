const express = require('express');
const router = express.Router();
const {
  getHoldings,
  addHolding,
  updateHolding,
  deleteHolding,
  updatePrices
} = require('../controllers/holdings');

router.get('/', getHoldings);
router.post('/', addHolding);
router.put('/:id', updateHolding);
router.delete('/:id', deleteHolding);
router.put('/prices/update', updatePrices);

module.exports = router;