//
//  Stock.swift
//  StockHolding
//
//  Created by Nishant Kumar on 17/11/24.
//

import Foundation

struct Stock: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double

    var currentValue: Double {
        return ltp * Double(quantity)
    }
    
    var totalInvestment: Double {
        return avgPrice * Double(quantity)
    }
    
    var totalPNL: Double {
        return currentValue - totalInvestment
    }
    
    var todayPNL: Double {
        return (close - ltp) * Double(quantity)
    }
}
