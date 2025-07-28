
const apiKey = '7UW1HZ8N4JS40AB0'; // 替换为你自己的 Alpha Vantage API key
const ctx = document.getElementById('chart').getContext('2d');
ctx.canvas.width = 1000;
ctx.canvas.height = 300;

let chart = new Chart(ctx, {
  type: 'candlestick',
  data: {
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
    scales: {
      x: {
        type: 'time',
        time: {
          unit: 'day'
        }
      },
      y: {
        type: 'linear'
      }
    }
  }
});

async function getRealData(ticker, days) {
  const url = `https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=${ticker}&outputsize=compact&apikey=${apiKey}`;
  
  try {
    const res = await fetch(url);
    const json = await res.json();
    const timeSeries = json["Time Series (Daily)"];
    if (!timeSeries) {
      alert("获取数据失败，请检查 API Key 或股票代码");
      return;
    }

    const entries = Object.entries(timeSeries)
      .slice(0, days)
      .map(([date, value]) => ({
        x: luxon.DateTime.fromISO(date).toMillis(),
        o: parseFloat(value["1. open"]),
        h: parseFloat(value["2. high"]),
        l: parseFloat(value["3. low"]),
        c: parseFloat(value["4. close"])
      }))
      .reverse();

    chart.data.datasets[0].label = `${ticker.toUpperCase()} Stock Data`;
    chart.data.datasets[0].data = entries;
    chart.data.datasets[1].data = entries.map(d => ({ x: d.x, y: d.c }));
    chart.update();
  } catch (err) {
    console.error("API Error:", err);
    alert("数据加载出错，请检查网络连接或 API 限额。");
  }
}

function updateChartSettings() {
  const dataset = chart.config.data.datasets[0];

  // 图表类型切换
  chart.config.type = document.getElementById('type').value;

  // y轴比例
  chart.options.scales.y.type = document.getElementById('scale-type').value;

  // 颜色方案
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

  // 边框设置
  const border = document.getElementById('border').value;
  if (border === 'false') {
    dataset.borderColors = 'rgba(0,0,0,0)';
  } else {
    delete dataset.borderColors;
  }

  // 是否混合线图
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

// 监听其他 select 控件的变化
[...document.querySelectorAll('select')].forEach(el => {
  el.addEventListener('change', updateChartSettings);
});
