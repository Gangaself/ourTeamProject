document.addEventListener('DOMContentLoaded', function() {
    // 默认加载投资组合数据
    loadPortfolios();
    
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
      loadPortfolios();
    } else if (tabName === 'assets') {
      loadAssets();
    }
  }
  
  // 加载投资组合数据
  async function loadPortfolios() {
    try {
      const response = await fetch('/api/portfolio');
      const portfolios = await response.json();
      const portfolioList = document.getElementById('portfolio-list');
      
      portfolioList.innerHTML = '';
      
      if (portfolios.length === 0) {
        portfolioList.innerHTML = '<p>暂无投资组合</p>';
        return;
      }
      
      portfolios.forEach(portfolio => {
        const portfolioItem = document.createElement('div');
        portfolioItem.className = 'portfolio-item';
        portfolioItem.innerHTML = `
          <div class="portfolio-info">
            <span class="portfolio-name">${portfolio.name}</span>
            <span class="portfolio-desc">${portfolio.description}</span>
          </div>
          <div class="portfolio-actions">
            <a href="/portfolio_performance.html?portfolio_id=${portfolio.id}" class="btn btn-primary">查看表现</a>
            <a href="/portfolio_assets.html?portfolio_id=${portfolio.id}" class="btn btn-secondary">查看资产</a>
          </div>
        `;
        portfolioList.appendChild(portfolioItem);
      });
    } catch (error) {
      console.error('加载投资组合失败:', error);
      document.getElementById('portfolio-list').innerHTML = '<p>加载数据失败，请稍后重试</p>';
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