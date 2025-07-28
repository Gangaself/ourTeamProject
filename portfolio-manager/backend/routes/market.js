const express = require('express');
const router = express.Router();
const { getMarketData, updateMarketData } = require('../controllers/market');

router.get('/', getMarketData);
router.post('/:symbol/update', updateMarketData);

module.exports = router;