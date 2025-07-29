const ctx = document.getElementById('chart').getContext('2d');
ctx.canvas.width = 1000;
ctx.canvas.height = 300;

let chart = new Chart(ctx, {
  type: 'candlestick',
  data: {
    labels: [], // 用于交易日顺序轴
    datasets: [{
      label: 'Stock Data',
      data: []
    }, {
      label: 'Close price',
      type: 'line',
      data: [],
      hidden: true
    }]
  },
  options: {
    responsive: true,
    parsing: false,
    scales: {
      x: {
        type: 'category', // 非时间轴，消除非交易日空隙
        ticks: {
          callback: function(value, index) {
            const label = chart.data.labels[index];
            return luxon.DateTime.fromMillis(label).toFormat("MM-dd");
          }
        }
      },
      y: {
        type: 'linear'
      }
    }
  }
});

async function getRealData(ticker, days) {
  const url = `https://apidojo-yahoo-finance-v1.p.rapidapi.com/api/yahoo/hi/history/${ticker}/1d`;
  
  try {
    const res = await fetch(url, {
      method: 'GET',
      headers: {
        'X-RapidAPI-Key': '98e1e233cbmsh2512df30938f3bcp1b13a4jsnf63c762db500', // 替换为你的 RapidAPI Key
        'X-RapidAPI-Host': 'apidojo-yahoo-finance-v1.p.rapidapi.com'
      }
    });

    const json = await res.json();
    const prices = json.items.result;

    if (!prices || prices.length === 0) {
      alert("获取数据失败，请检查股票代码或 API 限制");
      return;
    }

    const sliced = prices.slice(-days).map(d => {
      return {
        x: luxon.DateTime.fromISO(d.date).toMillis(),
        o: d.open,
        h: d.high,
        l: d.low,
        c: d.close
      };
    });

    const labels = sliced.map(d => d.x); // 每个交易日的时间戳

    chart.data.labels = labels;
    chart.data.datasets[0].label = `${ticker.toUpperCase()} Stock Data`;
    chart.data.datasets[0].data = sliced.map((d, i) => ({
      x: i,
      o: d.o,
      h: d.h,
      l: d.l,
      c: d.c
    }));
    chart.data.datasets[1].data = sliced.map((d, i) => ({
      x: i,
      y: d.c
    }));
    chart.update();
  } catch (err) {
    console.error("API Error:", err);
    alert("数据加载出错，请检查网络连接或 RapidAPI Key。");
  }
}

function updateChartSettings() {
  const dataset = chart.config.data.datasets[0];
  chart.config.type = document.getElementById('type').value;
  chart.options.scales.y.type = document.getElementById('scale-type').value;

  const colorScheme = document.getElementById('color-scheme').value;
  if (colorScheme === 'neon') {
    dataset.backgroundColors = {
      up: '#01ff01',
      down: '#fe0000',
      unchanged: '#999',
    };
  } else {
    delete dataset.backgroundColors;
  }

  const border = document.getElementById('border').value;
  if (border === 'false') {
    dataset.borderColors = 'rgba(0,0,0,0)';
  } else {
    delete dataset.borderColors;
  }

  const mixed = document.getElementById('mixed').value;
  chart.data.datasets[1].hidden = mixed === 'false';

  chart.update();
}

document.getElementById('update').addEventListener('click', updateChartSettings);
document.getElementById('loadData').addEventListener('click', () => {
  const ticker = document.getElementById('ticker').value;
  const days = parseInt(document.getElementById('days').value);
  getRealData(ticker, days);
});

[...document.querySelectorAll('select')].forEach(el => {
  el.addEventListener('change', updateChartSettings);
});
