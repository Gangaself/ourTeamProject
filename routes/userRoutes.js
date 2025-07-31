import { Router } from 'express';
const router = Router();
import connection from '../config/db.js';


router.get('/', async (req, res) => {
  try {
    const [rows] = await connection.query('SELECT * FROM user WHERE user_id = 1');
    res.json(rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Database error' });
  }
});


export default router;