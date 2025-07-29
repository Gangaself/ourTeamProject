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
      alert('Portfolio name cannot be empty');
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
        alert('Portfolio added successfully');
        hideAddForm();
        loadPortfolios();
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Add failed');
      }
    } catch (error) {
      console.error('Add Error:', error);
      alert('Error adding portfolio:' + error.message);
    }
  }
  
  // 加载组合列表
  async function loadPortfolios() {
    try {
      const res = await fetch('/api/portfolio');
      if (!res.ok) throw new Error('Failed to obtain data');
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
              <i class="fas fa-chart-line"></i> View portfolio performance
            </a>
            <a href="/portfolio_assets.html?portfolio_id=${p.id}" class="action-link">
              <i class="fas fa-coins"></i> View Assets
            </a>
            <a href="#" onclick="showEditForm(${p.id}, '${escapeHtml(p.name)}', '${escapeHtml(p.description)}', this); return false;" class="action-link">
              <i class="fas fa-edit"></i> Modify portfolio
            </a>
            <a href="#" onclick="handleDeletePortfolio(${p.id}, this); return false;" class="action-link" style="color: var(--danger-color)">
              <i class="fas fa-trash-alt"></i> Delete portfolio
            </a>
          </div>
          <div id="edit-form-${p.id}" class="form-container" style="display: none; width: 100%; margin-top: 15px;">
            <div class="form-row">
              <label><i class="fas fa-tag"></i> Portfolio Name</label>
              <input type="text" id="edit-name-${p.id}" value="${escapeHtml(p.name)}" placeholder="Please enter a portfolio name">
            </div>
            <div class="form-row">
              <label><i class="fas fa-align-left"></i> Portfolio Description</label>
              <input type="text" id="edit-desc-${p.id}" value="${escapeHtml(p.description)}" placeholder="Please enter a portfolio description">
            </div>
            <div class="form-row">
              <button class="btn btn-success" onclick="handleUpdatePortfolio(${p.id})">
                <i class="fas fa-check"></i> Submit
              </button>
              <button class="btn btn-danger" onclick="hideEditForm(${p.id})">
                <i class="fas fa-times"></i> Cancel
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
            <i class="fas fa-exclamation-triangle"></i> Failed to load portfolio list, please refresh and try again
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
      alert('Portfolio name cannot be empty');
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
        alert('Portfolio update successful');
        hideEditForm(id);
        loadPortfolios();
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Update failed');
      }
    } catch (error) {
      console.error('Update Error:', error);
      alert('Error updating portfolio: ' + error.message);
    }
  }
  
  // 删除组合
  async function handleDeletePortfolio(id, element) {
    if (!confirm('Are you sure you want to delete this portfolio?')) return;
    
    try {
      const response = await fetch(`/api/portfolio/${id}`, {
        method: 'DELETE'
      });
      
      if (response.ok) {
        element.closest('.portfolio-item').remove();
        alert('Portfolio deleted successfully');
      } else {
        const errorData = await response.json();
        throw new Error(errorData.message || 'Deletion failed');
      }
    } catch (error) {
      console.error('Deleting Errors:', error);
      alert('Error deleting portfolio: ' + error.message);
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