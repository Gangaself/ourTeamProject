// portfolioFunctions.js

// 显示添加表单
function showAddForm() {
    document.getElementById('add-form').style.display = 'block';
    document.getElementById('add-name').focus();
  }
  
  // 隐藏添加表单
  function hideAddForm() {
    document.getElementById('add-form').style.display = 'none';
    document.getElementById('add-name').value = '';
    document.getElementById('add-desc').value = '';
  }
  
  // 处理添加组合
  async function handleAddPortfolio() {
    const name = document.getElementById('add-name').value.trim();
    const desc = document.getElementById('add-desc').value.trim();
    
    if (!name) {
      alert('组合名称不能为空');
      document.getElementById('add-name').focus();
      return;
    }
    
    try {
      const response = await fetch('/api/portfolio', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: name,
          description: desc
        })
      });
      
      if (response.ok) {
        alert('组合添加成功');
        hideAddForm();
        loadPortfolios();
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || '添加失败');
      }
    } catch (error) {
      console.error('添加错误:', error);
      alert('添加组合时出错: ' + error.message);
    }
  }
  
  // 加载组合列表
  async function loadPortfolios() {
    try {
      const res = await fetch('/api/portfolio');
      if (!res.ok) throw new Error('获取数据失败');
      const portfolios = await res.json();
      const list = document.getElementById('portfolio-list');
      list.innerHTML = '';
      
      portfolios.forEach(p => {
        const li = document.createElement('li');
        li.className = 'portfolio-item';
        li.innerHTML = `
          <div class="portfolio-info">
            <div class="portfolio-name">${escapeHtml(p.name)}</div>
            <div class="portfolio-desc">${escapeHtml(p.description)}</div>
          </div>
          <div class="portfolio-actions">
            <a href="/portfolio_performance.html?portfolio_id=${p.id}" class="action-link">
              <i class="fas fa-chart-line"></i> 查看表现
            </a>
            <a href="/portfolio_assets.html?portfolio_id=${p.id}" class="action-link">
              <i class="fas fa-coins"></i> 查看资产
            </a>
            <a href="#" onclick="showEditForm(${p.id}, '${escapeHtml(p.name)}', '${escapeHtml(p.description)}', this); return false;" class="action-link">
              <i class="fas fa-edit"></i> 修改
            </a>
            <a href="#" onclick="handleDeletePortfolio(${p.id}, this); return false;" class="action-link" style="color: var(--danger-color)">
              <i class="fas fa-trash-alt"></i> 删除
            </a>
          </div>
          <div id="edit-form-${p.id}" class="form-container" style="display: none; width: 100%; margin-top: 15px;">
            <div class="form-row">
              <label><i class="fas fa-tag"></i> 名字</label>
              <input type="text" id="edit-name-${p.id}" value="${escapeHtml(p.name)}" placeholder="组合名称">
            </div>
            <div class="form-row">
              <label><i class="fas fa-align-left"></i> 描述</label>
              <input type="text" id="edit-desc-${p.id}" value="${escapeHtml(p.description)}" placeholder="组合描述">
            </div>
            <div class="form-row">
              <button class="btn btn-success" onclick="handleUpdatePortfolio(${p.id})">
                <i class="fas fa-check"></i> 保存
              </button>
              <button class="btn btn-danger" onclick="hideEditForm(${p.id})">
                <i class="fas fa-times"></i> 取消
              </button>
            </div>
          </div>
        `;
        list.appendChild(li);
      });
    } catch (error) {
      console.error('Error:', error);
      document.getElementById('portfolio-list').innerHTML = `
        <li class="portfolio-item">
          <div style="color: var(--danger-color); text-align: center; width: 100%;">
            <i class="fas fa-exclamation-triangle"></i> 加载组合列表失败，请刷新重试
          </div>
        </li>
      `;
    }
  }
  
  // 显示编辑表单
  function showEditForm(id, name, desc, element) {
    document.querySelectorAll('.form-container').forEach(form => {
      form.style.display = 'none';
    });
    const form = document.getElementById(`edit-form-${id}`);
    form.style.display = 'block';
    form.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
  }
  
  // 隐藏编辑表单
  function hideEditForm(id) {
    const form = document.getElementById(`edit-form-${id}`);
    form.style.display = 'none';
  }
  
  // 更新组合
  async function handleUpdatePortfolio(id) {
    const newName = document.getElementById(`edit-name-${id}`).value.trim();
    const newDesc = document.getElementById(`edit-desc-${id}`).value.trim();
    
    if (!newName) {
      alert('组合名称不能为空');
      return;
    }
    
    try {
      const response = await fetch(`/api/portfolio/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: newName,
          description: newDesc
        })
      });
      
      if (response.ok) {
        alert('组合更新成功');
        hideEditForm(id);
        loadPortfolios();
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || '更新失败');
      }
    } catch (error) {
      console.error('更新错误:', error);
      alert('更新组合时出错: ' + error.message);
    }
  }
  
  // 删除组合
  async function handleDeletePortfolio(id, element) {
    if (!confirm('确定要删除这个组合吗？')) return;
    
    try {
      const response = await fetch(`/api/portfolio/${id}`, {
        method: 'DELETE'
      });
      
      if (response.ok) {
        element.closest('.portfolio-item').remove();
        alert('组合删除成功');
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || '删除失败');
      }
    } catch (error) {
      console.error('删除错误:', error);
      alert('删除组合时出错: ' + error.message);
    }
  }
  
  // HTML转义
  function escapeHtml(str) {
    if (!str) return '';
    return str.replace(/[&<>'"]/g, tag => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;',
      "'": '&#39;', '"': '&quot;'
    }[tag]));
  }
  
  // 页面加载时初始化
  document.addEventListener('DOMContentLoaded', function() {
    loadPortfolios();
  });