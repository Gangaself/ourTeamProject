const MarketData = require('../models/MarketData');
const Holding = require('../models/Holding');
const alphaVantage = require('../services/alphaVantage');

const getMarketData = async (req, res) => {
  try {
    // 获取主要指数
    const indices = await MarketData.getIndices();
    
    // 获取持仓中的股票数据
    const holdings = await Holding.findAll();
    const symbols = [...new Set(holdings.map(h => h.symbol))];
    
    const stocks = await Promise.all(
      symbols.map(symbol => MarketData.findBySymbol(symbol))
    );
    
    res.json({
      indices,
      stocks: stocks.filter(Boolean) // 过滤掉null值
    });
  } catch (err) {
    console.error('Error fetching market data:', err);
    res.status(500).json({ message: 'Failed to fetch market data' });
  }
};

const updateMarketData = async (req, res) => {
  try {
    const { symbol } = req.params;
    const updatedData = await alphaVantage.fetchStockData(symbol);
    
    if (!updatedData) {
      return res.status(404).json({ message: 'Stock data not found' });
    }
    
    const savedData = await MarketData.updateOrCreate(updatedData);
    res.json(savedData);
  } catch (err) {
    console.error(`Error updating market data for ${req.params.symbol}:`, err);
    res.status(400).json({ message: 'Failed to update market data' });
  }
};

module.exports = {
  getMarketData,
  updateMarketData
};