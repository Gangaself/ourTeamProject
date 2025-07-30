import {
  getAllTransactions,
  createTransaction,
  deleteTransaction,
  searchTransactions
} from '../services/transactionService.js';

const listTransactions = async (req, res) => {
  const data = await getAllTransactions();
  res.json(data);
};
const searchTransactionRecords = async (req, res) => {
  try {
    const { asset_type, symbol, name, start_date, end_date } = req.query;
    const data = await searchTransactions({ asset_type, symbol, name, start_date, end_date });
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const addTransaction = async (req, res) => {
  const result = await createTransaction(req.body);
  res.json({ message: 'Transaction added', id: result.insertId });
};

const removeTransaction = async (req, res) => {
  const id = req.params.id;
  await deleteTransaction(id);
  res.json({ message: 'Transaction deleted' });
};

export { listTransactions, addTransaction, removeTransaction,searchTransactionRecords };
