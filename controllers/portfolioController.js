import { getAllPortfolios, createPortfolio, deletePortfolio } from '../services/portfolioService.js';

const listPortfolios = async (req, res) => {
    const data = await getAllPortfolios();
    res.json(data);
};

const addPortfolio = async (req, res) => {
    const result = await createPortfolio(req.body);
    res.json({ message: 'Portfolio added', id: result.insertId });
};

const removePortfolio = async (req, res) => {
    const id = req.params.id;
    await deletePortfolio(id);
    res.json({ message: 'Portfolio deleted' });
};

export { listPortfolios, addPortfolio, removePortfolio };
