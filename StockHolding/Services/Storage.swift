//
//  Storage.swift
//  StockHolding
//
//  Created by Nishant Kumar on 20/11/24.
//

import Foundation

final class Storage {
    static let shared = Storage()
    
    private init() {}
    
    func saveHoldings(holdings: [Stock]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(holdings)
            UserDefaults.standard.set(data, forKey: Constants.kUserDefaultStorageKey)
        } catch {
            print("Unable to Encode Holdings (\(error))")
        }
    }
    
    func getHoldings() -> [Stock] {
        if let data = UserDefaults.standard.data(forKey: Constants.kUserDefaultStorageKey) {
            do {
                let decoder = JSONDecoder()
                let stocks = try decoder.decode([Stock].self, from: data)
                return stocks
            } catch {
                print("Unable to Decode Holdings (\(error))")
            }
        }
        return []
    }
}

