import express from 'express';
import {
  listTransactions,
  addTransaction,
  removeTransaction,
  searchTransactionRecords
} from '../controllers/transactionController.js';

const router = express.Router();

router.get('/search', searchTransactionRecords); 
router.get('/', listTransactions);
router.post('/', addTransaction);
router.delete('/:id', removeTransaction);

export default router;
