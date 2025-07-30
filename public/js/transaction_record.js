const API_URL = '/api/transaction';

document.addEventListener('DOMContentLoaded', () => {
  loadTransactions();

  const form = document.getElementById('transactionForm');
  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());

    // 转数字字段
    data.quantity = parseFloat(data.quantity);
    data.price = parseFloat(data.price);
    data.portfolio_id = parseInt(data.portfolio_id);

    const res = await fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });

    if (res.ok) {
      form.reset();
      loadTransactions();
    }
  });
});

async function loadTransactions() {
  const res = await fetch(API_URL);
  const data = await res.json();
  const tbody = document.querySelector('#transactionTable tbody');
  tbody.innerHTML = '';

  data.forEach((tx) => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${tx.id}</td>
      <td>${tx.type}</td>
      <td>${tx.name || ''}</td>
      <td>${tx.symbol}</td>
      <td>${tx.quantity}</td>
      <td>${tx.price}</td>
      <td>${tx.amount}</td>
      <td>${tx.trade_date}</td>
      <td><button onclick="deleteTransaction(${tx.id})">删除</button></td>
    `;
    tbody.appendChild(tr);
  });
}

async function deleteTransaction(id) {
  if (!confirm('确认删除此交易记录？')) return;
  await fetch(`${API_URL}/${id}`, { method: 'DELETE' });
  loadTransactions();
}
