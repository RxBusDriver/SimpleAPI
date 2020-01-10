//
//  ResultData.swift
//  SimpleExchangeRate
//
//  Created by Daheen Lee on 2020/01/02.
//  Copyright © 2020 allwhite. All rights reserved.
//

import UIKit

struct ResultData: Decodable {
    static let empty = ResultData(
    base: "USD",
    date : "2020.01.06",
    lastUpdatedTime: 100,
    rates: [Rate(code: "KRW", rate: 1200.0)])
    
    let base: String?
    let date: String?
    let lastUpdatedTime: Int?
    let rates: [Rate]?
    
    enum CodingKeys: String, CodingKey {
        case base, date, rates
        case lastUpdatedTime = "time_last_updated"
    }
    
    init(base: String,
         date: String,
         lastUpdatedTime: Int,
         rates: [Rate]) {
        self.base = base
        self.date = date
        self.lastUpdatedTime = lastUpdatedTime
        self.rates = rates
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.base = try? values.decode(String.self, forKey: .base)
        self.date = try? values.decode(String.self, forKey: .date)
        self.lastUpdatedTime = try? values.decode(Int.self, forKey: .lastUpdatedTime)
        let rawRates = try? values.decode([String: Double].self, forKey: .rates)
        self.rates = rawRates?.map({ (key, value) -> Rate in
            return Rate(code: key, rate: value)
        })
    }
    

}
