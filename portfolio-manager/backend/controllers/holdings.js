const Holding = require('../models/Holding');

const getHoldings = async (req, res) => {
  try {
    const holdings = await Holding.findAll();
    res.json(holdings);
  } catch (err) {
    console.error('Error fetching holdings:', err);
    res.status(500).json({ message: 'Failed to fetch holdings' });
  }
};

const addHolding = async (req, res) => {
  try {
    const holding = await Holding.create(req.body);
    res.status(201).json(holding);
  } catch (err) {
    console.error('Error adding holding:', err);
    res.status(400).json({ message: 'Failed to add holding' });
  }
};

const updateHolding = async (req, res) => {
  try {
    const holding = await Holding.update(req.params.id, req.body);
    if (!holding) {
      return res.status(404).json({ message: 'Holding not found' });
    }
    res.json(holding);
  } catch (err) {
    console.error('Error updating holding:', err);
    res.status(400).json({ message: 'Failed to update holding' });
  }
};

const deleteHolding = async (req, res) => {
  try {
    await Holding.delete(req.params.id);
    res.json({ id: req.params.id });
  } catch (err) {
    console.error('Error deleting holding:', err);
    res.status(500).json({ message: 'Failed to delete holding' });
  }
};

const updatePrices = async (req, res) => {
  try {
    const { updates } = req.body;
    if (!updates || !Array.isArray(updates)) {
      return res.status(400).json({ message: 'Invalid updates format' });
    }
    
    const results = await Holding.updatePrices(updates);
    res.json({ results });
  } catch (err) {
    console.error('Error updating prices:', err);
    res.status(400).json({ message: 'Failed to update prices' });
  }
};

module.exports = {
  getHoldings,
  addHolding,
  updateHolding,
  deleteHolding,
  updatePrices
};