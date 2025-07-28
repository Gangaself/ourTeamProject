const express = require('express');
const router = express.Router();
const {
  getNetWorth,
  getAssetAllocation,
  getFeesAnalysis,
  getPerformance
} = require('../controllers/analysis');

router.get('/net-worth', getNetWorth);
router.get('/asset-allocation', getAssetAllocation);
router.get('/fees', getFeesAnalysis);
router.get('/performance', getPerformance);

module.exports = router;