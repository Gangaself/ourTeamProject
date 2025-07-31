document.addEventListener('DOMContentLoaded', function() {
  // 默认显示投资组合内容
  document.getElementById('portfolio-content').style.display = 'block';
  document.getElementById('assets-content').style.display = 'none';
  document.getElementById('user-content').style.display = 'none';
  
  // 设置菜单点击事件
  document.getElementById('portfolio-tab').addEventListener('click', function(e) {
    e.preventDefault();
    switchTab('portfolio');
  });
  
  document.getElementById('assets-tab').addEventListener('click', function(e) {
    e.preventDefault();
    switchTab('assets');
  });

  // 添加用户中心点击事件
  document.getElementById('user-tab').addEventListener('click', function(e) {
    e.preventDefault();
    switchTab('user');
  });
});

// 切换标签页
function switchTab(tabName) {
  // 更新菜单激活状态
  document.querySelectorAll('.nav-links a').forEach(link => {
    link.classList.remove('active');
  });
  document.getElementById(`${tabName}-tab`).classList.add('active');
  
  // 显示/隐藏内容区域
  document.getElementById('portfolio-content').style.display = 'none';
  document.getElementById('assets-content').style.display = 'none';
  document.getElementById('user-content').style.display = 'none';
  document.getElementById(`${tabName}-content`).style.display = 'block';
  
  // 根据需要加载数据
  if (tabName === 'portfolio') {
    loadPortfolios();
  } else if (tabName === 'assets') {
    loadAssets();
  } else if (tabName === 'user') {
    loadUserData();
  }
}

// 加载资产数据
async function loadAssets() {
  try {
    const response = await fetch('/api/assets');
    const assets = await response.json();
    const assetList = document.getElementById('assets-list');
    
    assetList.innerHTML = '';
    
    if (assets.length === 0) {
      assetList.innerHTML = '<p>No asset data yet</p>';
      return;
    }
    
    assets.forEach(asset => {
      const assetItem = document.createElement('div');
      assetItem.className = 'asset-item';
      assetItem.innerHTML = `
        <div class="asset-info">
          <span class="asset-name">${asset.name}</span>
          <span class="asset-type">${asset.type}</span>
        </div>
        <div class="asset-actions">
          <span class="asset-value">${asset.value}</span>
        </div>
      `;
      assetList.appendChild(assetItem);
    });
  } catch (error) {
    console.error('Failed to load asset:', error);
    document.getElementById('assets-list').innerHTML = '<p>Failed to load data, please try again later</p>';
  }
}

// 加载用户数据
async function loadUserData() {
  try {
    const response = await fetch('/api/user');
    if (!response.ok) throw new Error('Failed to obtain user data');
    
    const userData = await response.json();
    
    // 创建货币格式化器
    const formatter = new Intl.NumberFormat(undefined, {
      style: 'currency',
      currency: userData.currency || 'USD'
    });
    
    // 显示用户数据
    document.getElementById('username').textContent = userData.username || '未设置';
    document.getElementById('email').textContent = userData.email || '未设置';
    document.getElementById('initial-amount').textContent = formatter.format(userData.initial_amount || 0);
    
    const balanceElement = document.getElementById('balance');
    balanceElement.textContent = formatter.format(userData.balance || 0);
    balanceElement.className = userData.balance >= 0 ? 'amount-positive' : 'amount-negative';
    
    document.getElementById('currency').textContent = getCurrencyName(userData.currency) || userData.currency || 'USD';
    document.getElementById('created-at').textContent = 
      userData.created_at ? formatDateTime(userData.created_at) : '未知';
    document.getElementById('updated-at').textContent = 
      userData.updated_at ? formatDateTime(userData.updated_at) : '未知';
      
  } catch (error) {
    console.error('Failed to obtain user data:', error);
    document.getElementById('user-info').innerHTML = `
      <div class="error-message">
        <i class="fas fa-exclamation-triangle"></i> Failed to obtain user data: ${error.message}
      </div>
    `;
  }
}

// 辅助函数：获取货币完整名称
function getCurrencyName(currencyCode) {
  const CURRENCY_NAMES = {
    USD: 'Dollar',
    CNY: 'RMB',
    EUR: '欧元',
    JPY: '日元',
    GBP: '英镑',
    HKD: '港币'
  };
  return CURRENCY_NAMES[currencyCode];
}

// 辅助函数：格式化日期时间
function formatDateTime(dateTimeString) {
  const options = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  };
  return new Date(dateTimeString).toLocaleString(undefined, options);
}