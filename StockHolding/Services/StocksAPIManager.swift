//
//  StocksAPIManager.swift
//  StockHolding
//
//  Created by Nishant Kumar on 17/11/24.
//

import Foundation

enum APINetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingError
}

class StocksAPIManager {
    
    func fetchHoldings(completion: @escaping (Result<[Stock], APINetworkError>) -> Void) {
        guard let url = URL(string: Constants.kBaseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let holdings = try decoder.decode(APIResponse.self, from: data)
                completion(.success(holdings.data.userHolding))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}
