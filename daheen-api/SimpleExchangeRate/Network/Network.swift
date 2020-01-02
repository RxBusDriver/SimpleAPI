//
//  Network.swift
//  SimpleExchangeRate
//
//  Created by Daheen Lee on 2020/01/02.
//  Copyright © 2020 allwhite. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NetworkService {
    private let session = URLSession.shared
    
    init() {
        
    }
    
    func getRates(for currency: CurrencyCode) -> Observable<Result<ResultData, ExchangeRateError>> {
        let urlString = "https://api.exchangerate-api.com/v4/latest/USD"
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return session.rx.data(request: request)
            .map { data in
            do {
                let result = try JSONDecoder().decode(ResultData.self, from: data)
                return .success(result)
            } catch {
                return .failure(.error("api error"))
            }
        }
    }
}

enum ExchangeRateError: Error {
    case error(String)
    case empty
}
