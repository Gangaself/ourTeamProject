const { pool } = require('../config/db');
const Holding = require('../models/Holding');
const MarketData = require('../models/MarketData');

const sampleHoldings = [
  {
    symbol: 'AAPL',
    name: 'Apple Inc.',
    quantity: 10,
    purchase_price: 150,
    current_price: 175,
    account_type: 'Brokerage',
    account_name: 'Fidelity Brokerage',
    category: 'US Stocks',
    fees: 0
  },
  {
    symbol: 'MSFT',
    name: 'Microsoft Corporation',
    quantity: 5,
    purchase_price: 250,
    current_price: 300,
    account_type: 'Brokerage',
    account_name: 'Fidelity Brokerage',
    category: 'US Stocks',
    fees: 0
  },
  {
    symbol: 'CASH',
    name: 'Cash',
    quantity: 10000,
    purchase_price: 1,
    current_price: 1,
    account_type: 'Cash',
    account_name: 'Wells Fargo Checking',
    category: 'Cash',
    fees: 0
  }
];

const sampleMarketData = [
  {
    symbol: '^GSPC',
    name1: 'S&P 500',
    price: 4500.32,
    change1: -32.45,
    change_percent: -0.72,
    sector: 'Index',
    exchange: 'NYSE',
    currency: 'USD'
  },
  {
    symbol: '^DJI',
    name1: 'Dow Jones Industrial Average',
    price: 34500.12,
    change1: 120.45,
    change_percent: 0.35,
    sector: 'Index',
    exchange: 'NYSE',
    currency: 'USD'
  },
  {
    symbol: '^IXIC',
    name1: 'NASDAQ Composite',
    price: 14200.56,
    change1: -150.78,
    change_percent: -1.05,
    sector: 'Index',
    exchange: 'NASDAQ',
    currency: 'USD'
  },
  {
    symbol: 'AAPL',
    name1: 'Apple Inc.',
    price: 175.25,
    change1: 2.50,
    change_percent: 1.45,
    sector: 'Technology',
    exchange: 'NASDAQ',
    currency: 'USD'
  },
  {
    symbol: 'MSFT',
    name1: 'Microsoft Corporation',
    price: 300.75,
    change1: 3.25,
    change_percent: 1.09,
    sector: 'Technology',
    exchange: 'NASDAQ',
    currency: 'USD'
  }
];

const initDB = async () => {
  try {
    // 清空现有数据
     await pool.query('DELETE FROM holdings');
    await pool.query('DELETE FROM market_data');
    
    // 插入示例持仓数据
    for (const holding of sampleHoldings) {
      await Holding.create(holding);
    }
    
    // 插入示例市场数据
    for (const market of sampleMarketData) {
      await MarketData.updateOrCreate(market);
    }
    
    console.log('Database initialized with sample data');
    process.exit(0);
  } catch (err) {
    console.error('Error initializing database:', err);
    process.exit(1);
  }
};

initDB();