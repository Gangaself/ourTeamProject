import mysql from 'mysql2/promise';

const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'n3u3da!',
    database: 'portfolio_manager'
});

export default connection;
