const Holding = require('../models/Holding');
const calculate = require('../services/calculations');

const getNetWorth = async (req, res) => {
  try {
    const holdings = await Holding.findAll();
    
    const {
      totalNetWorth,
      totalCash,
      totalInvestments,
      cashAccounts,
      investmentAccounts
    } = calculate.calculateNetWorth(holdings);

    res.json({
      totalNetWorth,
      totalCash,
      totalInvestments,
      cashAccounts,
      investmentAccounts
    });
  } catch (err) {
    console.error('Error calculating net worth:', err);
    res.status(500).json({ message: 'Failed to calculate net worth' });
  }
};

const getAssetAllocation = async (req, res) => {
  try {
    const holdings = await Holding.findAll();
    const allocation = calculate.calculateAssetAllocation(holdings);
    res.json(allocation);
  } catch (err) {
    console.error('Error calculating asset allocation:', err);
    res.status(500).json({ message: 'Failed to calculate asset allocation' });
  }
};

const getFeesAnalysis = async (req, res) => {
  try {
    const holdings = await Holding.findAll();
    const fees = calculate.calculateFees(holdings);
    res.json(fees);
  } catch (err) {
    console.error('Error calculating fees analysis:', err);
    res.status(500).json({ message: 'Failed to calculate fees analysis' });
  }
};

const getPerformance = async (req, res) => {
  try {
    const holdings = await Holding.findAll();
    const performance = calculate.calculatePerformance(holdings);
    res.json(performance);
  } catch (err) {
    console.error('Error calculating performance:', err);
    res.status(500).json({ message: 'Failed to calculate performance' });
  }
};

module.exports = {
  getNetWorth,
  getAssetAllocation,
  getFeesAnalysis,
  getPerformance
};