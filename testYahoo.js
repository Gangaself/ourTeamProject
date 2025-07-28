async function getCurrentPrice(symbol) {
    const url = `https://query1.finance.yahoo.com/v8/finance/chart/${symbol}`;
    const response = await fetch(url);
    const data = await response.json();
    return data.chart.result[0].meta.regularMarketPrice;
}

getCurrentPrice('AMZN').then(price => console.log(price));

async function getHistoricalData(symbol, start, end) {
    const startTime = Math.floor(new Date(start).getTime() / 1000);
    const endTime = Math.floor(new Date(end).getTime() / 1000);

    const url = `https://query1.finance.yahoo.com/v8/finance/chart/${symbol}?period1=${startTime}&period2=${endTime}&interval=1d`;

    const response = await fetch(url);
    const data = await response.json();

    const timestamps = data.chart.result[0].timestamp;
    const closes = data.chart.result[0].indicators.quote[0].close;

    return timestamps.map((t, i) => ({
        date: new Date(t * 1000),
        close: closes[i]
    }));
}

getHistoricalData('TSLA', '2023-01-01', '2023-12-31')
    .then(data => console.log(data));