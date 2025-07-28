import connection from '../config/db.js';

const getAllPortfolios = async () => {
    const [rows] = await connection.query('SELECT * FROM portfolio');
    return rows;
};

const createPortfolio = async (data) => {
    const { name, description } = data;
    const [result] = await connection.query(
        'INSERT INTO portfolio (name, description) VALUES (?, ?)',
        [name, description]
    );
    return result;
};

const deletePortfolio = async (id) => {
    const [result] = await connection.query('DELETE FROM portfolio WHERE id = ?', [id]);
    return result;
};

export { getAllPortfolios, createPortfolio, deletePortfolio };
