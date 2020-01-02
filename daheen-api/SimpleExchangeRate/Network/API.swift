//
//  API.swift
//  SimpleExchangeRate
//
//  Created by Daheen Lee on 2020/01/02.
//  Copyright © 2020 allwhite. All rights reserved.
//

import Foundation

struct ExchangeRateAPI {
    static let baseURL = "https://api.exchangerate-api.com/v4/latest/"
    
    static func url(for currency: CurrencyCode) -> String {
        return "\(baseURL)\(currency.rawValue)"
    }
}

