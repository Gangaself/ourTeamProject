const axios = require('axios');
const MarketData = require('../models/MarketData');

const API_KEY = process.env.ALPHA_VANTAGE_API_KEY;

const fetchStockData = async (symbol) => {
  try {
    if (!API_KEY) {
      console.warn('Alpha Vantage API key not configured - using mock data');
      return {
        symbol,
        name: symbol,
        price: Math.random() * 100 + 50,
        change: (Math.random() - 0.5) * 10,
        changePercent: (Math.random() - 0.5) * 5,
        sector: 'Technology',
        exchange: 'NASDAQ',
        currency: 'USD'
      };
    }

    const response = await axios.get(
      `https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${symbol}&apikey=${API_KEY}`
    );
    
    const quote = response.data['Global Quote'];
    if (!quote) {
      throw new Error('Invalid symbol or API response');
    }
    
    return {
      symbol,
      name: symbol, // 可以从其他API获取实际名称
      price: parseFloat(quote['05. price']),
      change: parseFloat(quote['09. change']),
      changePercent: parseFloat(quote['10. change percent'].replace('%', '')),
      sector: 'Technology', // 可以从其他API获取实际行业
      exchange: 'NASDAQ', // 可以从其他API获取实际交易所
      currency: 'USD'
    };
  } catch (err) {
    console.error(`Error fetching data for ${symbol}:`, err.message);
    return null;
  }
};

const updateAllMarketData = async () => {
  try {
    // 获取所有持仓中的股票代码
    const holdings = await Holding.findAll();
    const symbols = [...new Set(holdings.map(h => h.symbol))];
    
    // 获取主要指数
    const indices = ['^GSPC', '^DJI', '^IXIC'];
    const allSymbols = [...symbols, ...indices];
    
    // 批量更新数据
    const updatePromises = allSymbols.map(async (symbol) => {
      const data = await fetchStockData(symbol);
      if (data) {
        await MarketData.updateOrCreate(data);
      }
    });
    
    await Promise.all(updatePromises);
    console.log('Market data updated successfully');
  } catch (err) {
    console.error('Error updating market data:', err);
  }
};

module.exports = {
  fetchStockData,
  updateAllMarketData
};