import connection from '../config/db.js';

export async function getMarketById(id) {
  const [rows] = await connection.query(`SELECT * FROM market WHERE id = ?`, [id]);

  if (rows.length === 0) {
    throw new Error(`Market with id ${id} not found`);
  }

  return rows[0];
}

export async function addMarket(data) {
  const {
    type, symbol, name, current_price
  } = data;


  const [result] = await connection.query(
    `INSERT INTO market ( type, symbol, name, current_price)
     VALUES (?, ?, ?, ?)`,
    [

      type,
      symbol,
      name,
      toNullableNumber(current_price)
    ]
  );

  return { id: result.insertId, ...data };
}
function toNullableNumber(val) {
  return val === '' || val === null || val === undefined ? null : Number(val);
}





export async function deleteMarket(id) {
  await connection.query(`DELETE FROM market WHERE id = ?`, [id]);
}


