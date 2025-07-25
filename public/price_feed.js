const priceServiceUrl = 'https://jqjfct0r76.execute-api.us-east-1.amazonaws.com/default/PythonPandas';

document.getElementById("price-form").addEventListener("submit", function(event) {
    event.preventDefault();
    const form = event.target;
    getLivePrice(form.ticker.value, form.numdays.value).then(createTable);
});

async function getLivePrice(ticker, numDays = 1) {
    const response = await fetch(`${priceServiceUrl}?ticker=${ticker}&num_days=${numDays}`);
    return response.json();
}

function createTable(priceData) {
    let html = "<table class='table table-striped'><thead><tr><th>Date</th><th>Ticker</th><th>Close Price</th></tr></thead><tbody>";
    priceData.price_data.forEach(([date, price]) => {
        html += `<tr><td>${date}</td><td>${priceData.ticker}</td><td>${price}</td></tr>`;
    });
    html += "</tbody></table>";
    document.getElementById("price-div").innerHTML = html;
}
