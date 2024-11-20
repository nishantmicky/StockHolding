//
//  MockStocksAPIManager.swift
//  StockHoldingTests
//
//  Created by Nishant Kumar on 20/11/24.
//

import Foundation
@testable import StockHolding

class MockStocksAPIManager: StocksAPIManager {
    
    override func fetchHoldings(completion: @escaping (Result<[Stock], APINetworkError>) -> Void) {
        let mockData = """
        {
            "data": {
                "userHolding": [
                    {
                        "symbol": "MAHABANK",
                        "quantity": 990,
                        "ltp": 38,
                        "avgPrice": 35,
                        "close": 40
                    },
                    {
                        "symbol": "ICICI",
                        "quantity": 100,
                        "ltp": 118,
                        "avgPrice": 120,
                        "close": 105
                    }
                ]
            }
        }
        """.data(using: .utf8)
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(APIResponse.self, from: mockData!)
            completion(.success(response.data.userHolding))
        } catch {
            completion(.failure(.decodingError))
        }
    }
}
