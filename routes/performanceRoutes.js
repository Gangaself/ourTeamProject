import { Router } from 'express';
const router = Router();
import connection from '../config/db.js';

router.get('/:portfolio_id', async (req, res) => {
  const [rows] = await connection.query(
    `SELECT record_date, total_value FROM portfolio_performance WHERE portfolio_id = ? ORDER BY record_date`,
    [req.params.portfolio_id]
  );
  res.json(rows);
});

export default router;
