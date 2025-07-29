document.addEventListener('DOMContentLoaded', function() {
  // 默认显示投资组合内容
  document.getElementById('portfolio-content').style.display = 'block';
  document.getElementById('assets-content').style.display = 'none';
  
  // 设置菜单点击事件
  document.getElementById('portfolio-tab').addEventListener('click', function(e) {
    e.preventDefault();
    switchTab('portfolio');
  });
  
  document.getElementById('assets-tab').addEventListener('click', function(e) {
    e.preventDefault();
    switchTab('assets');
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
  document.getElementById(`${tabName}-content`).style.display = 'block';
  
  // 根据需要加载数据
  if (tabName === 'portfolio') {
    loadPortfolios(); // 这个函数现在在 portfolioFunctions.js 中
  } else if (tabName === 'assets') {
    loadAssets();
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
      assetList.innerHTML = '<p>暂无资产数据</p>';
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
    console.error('加载资产失败:', error);
    document.getElementById('assets-list').innerHTML = '<p>加载数据失败，请稍后重试</p>';
  }
}