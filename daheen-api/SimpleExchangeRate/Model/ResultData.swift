//
//  ResultData.swift
//  SimpleExchangeRate
//
//  Created by Daheen Lee on 2020/01/02.
//  Copyright © 2020 allwhite. All rights reserved.
//

import Foundation

struct ResultData: Decodable {
    let base: String?
    let date: String?
    let lastUpdatedTime: Int?
    let rates: [String: Double]?
    
    enum CodingKeys: String, CodingKey {
        case base, date, rates
        case lastUpdatedTime = "time_last_updated"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.base = try? values.decode(String.self, forKey: .base)
        self.date = try? values.decode(String.self, forKey: .date)
        self.lastUpdatedTime = try? values.decode(Int.self, forKey: .lastUpdatedTime)
        self.rates = try? values.decode([String: Double].self, forKey: .rates)
    }
}
