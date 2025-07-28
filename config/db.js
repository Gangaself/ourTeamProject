import mysql from 'mysql2/promise';

const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'song4346',
    database: 'portfolio_manager'
});

export default connection;
