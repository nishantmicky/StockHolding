//
//  Holdings.swift
//  StockHolding
//
//  Created by Nishant Kumar on 17/11/24.
//

import Foundation

struct APIResponse: Codable {
    let data: Holdings
}

struct Holdings: Codable {
    let userHolding: [Stock]
}
