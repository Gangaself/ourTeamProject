const calculateNetWorth = (holdings) => {
    const cashAccounts = holdings.filter(h => 
      ['Cash', 'Savings', 'Checking'].includes(h.account_type))
      .map(h => ({
        ...h,
        current_value: h.quantity * (h.current_price || h.purchase_price)
      }));
    
    const investmentAccounts = holdings.filter(h => 
      !['Cash', 'Savings', 'Checking'].includes(h.account_type))
      .map(h => ({
        ...h,
        current_value: h.quantity * (h.current_price || h.purchase_price)
      }));
    
    const totalCash = cashAccounts.reduce((sum, h) => sum + h.current_value, 0);
    const totalInvestments = investmentAccounts.reduce((sum, h) => sum + h.current_value, 0);
    const totalNetWorth = totalCash + totalInvestments;
    
    return {
      totalNetWorth,
      totalCash,
      totalInvestments,
      cashAccounts,
      investmentAccounts
    };
  };
  
  const calculateAssetAllocation = (holdings) => {
    return holdings.reduce((acc, h) => {
      const value = h.quantity * (h.current_price || h.purchase_price);
      acc[h.category] = (acc[h.category] || 0) + value;
      return acc;
    }, {});
  };
  
  const calculateFees = (holdings) => {
    const annualFees = holdings.reduce((sum, h) => sum + (h.fees || 0), 0);
    const projected30YearFees = annualFees * 30;
    
    return {
      annualFees,
      projected30YearFees
    };
  };
  
  const calculatePerformance = (holdings) => {
    const result = holdings.map(h => {
      const currentValue = h.quantity * (h.current_price || h.purchase_price);
      const costBasis = h.quantity * h.purchase_price;
      const gainLoss = currentValue - costBasis;
      const gainLossPercent = (gainLoss / costBasis) * 100;
      
      return {
        id: h.id,
        symbol: h.symbol,
        name: h.name,
        quantity: h.quantity,
        current_price: h.current_price || h.purchase_price,
        purchase_price: h.purchase_price,
        current_value: currentValue,
        cost_basis: costBasis,
        gain_loss: gainLoss,
        gain_loss_percent: gainLossPercent,
        account_type: h.account_type,
        category: h.category
      };
    });
    
    // 按盈亏排序
    const topGainers = [...result]
      .sort((a, b) => b.gain_loss_percent - a.gain_loss_percent)
      .slice(0, 5);
    
    const topLosers = [...result]
      .sort((a, b) => a.gain_loss_percent - b.gain_loss_percent)
      .slice(0, 5);
    
    const totalPerformance = result.reduce((acc, h) => {
      acc.total_value += h.current_value;
      acc.total_cost += h.cost_basis;
      return acc;
    }, { total_value: 0, total_cost: 0 });
    
    totalPerformance.total_gain = totalPerformance.total_value - totalPerformance.total_cost;
    totalPerformance.total_gain_percent = 
      (totalPerformance.total_gain / totalPerformance.total_cost) * 100;
    
    return {
      holdings: result,
      topGainers,
      topLosers,
      totalPerformance
    };
  };
  
  module.exports = {
    calculateNetWorth,
    calculateAssetAllocation,
    calculateFees,
    calculatePerformance
  };