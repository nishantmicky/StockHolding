//
//  HoldingsViewModel.swift
//  StockHolding
//
//  Created by Nishant Kumar on 17/11/24.
//

import Foundation
import UIKit

class HoldingsViewModel {
    private let stocksAPI: StocksAPIManager
    private(set) var holdings: [Stock] = []
    var isLoading: Bool = false

    // Closure to update the view
    var didUpdateHoldings: (() -> Void)?
    
    init(stocksAPI: StocksAPIManager) {
        self.stocksAPI = stocksAPI
    }

    func fetchHoldings() {
        isLoading = true
        
        stocksAPI.fetchHoldings { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let holdings):
                self?.holdings = holdings
                Storage.shared.saveHoldings(holdings: holdings)
            case .failure(let error):
                self?.holdings = Storage.shared.getHoldings()
                print("Error fetching holdings: \(error)")
            }
            self?.didUpdateHoldings?()
        }
    }
    
    func getCurrentValue() -> Double {
        var currentValue: Double = 0.0
        for stock in self.holdings {
            currentValue = currentValue + stock.currentValue
        }
        return currentValue
    }
    
    func getTotalInvestment() -> Double {
        var totalInvestment: Double = 0.0
        for stock in self.holdings {
            totalInvestment = totalInvestment + stock.totalInvestment
        }
        return totalInvestment
    }
    
    func getTodayPNL() -> Double {
        var todayPNL: Double = 0.0
        for stock in self.holdings {
            todayPNL = todayPNL + stock.todayPNL
        }
        return todayPNL
    }
    
    func getTodayPNLText() -> NSAttributedString {
        let todayPNL: Double = getTodayPNL()
        
        var todayPNLColor = UIColor.systemGreen
        if todayPNL < 0 {
            todayPNLColor = UIColor.systemRed
        }
        let text = Utils.formatAmount(amount: todayPNL)
        let todayPNLText = Utils.getAttributedString(text: text, fromIndex: 0, color: todayPNLColor)
        return todayPNLText
    }
    
    func getTotalPNLText() -> NSAttributedString {
        let totalPNL: Double = getCurrentValue() - getTotalInvestment()
        
        var totalPNLColor = UIColor.systemGreen
        if totalPNL < 0 {
            totalPNLColor = UIColor.systemRed
        }
        let text = Utils.formatAmount(amount: totalPNL) + Utils.getTotalPNLPercentage(part: totalPNL, total: getTotalInvestment())
        let totalPNLText = Utils.getAttributedString(text: text, fromIndex: 0, color: totalPNLColor)
        return totalPNLText
    }
}
