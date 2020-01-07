//
//  HomeViewModel.swift
//  SimpleExchangeRate
//
//  Created by dana.allwhite on 2020/01/07.
//  Copyright © 2020 allwhite. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct HomeViewModel {
    let baseCurrencySelected: BehaviorRelay<CurrencyCode> = BehaviorRelay(value: .USD)
    let selectedCurrencyRates: Driver<[Rate]>
    let lastUpdatedTime: Driver<String>
//    let errorMessage: Signal<String>
    
    private let exchangeRateAPI = ExchangeRateAPI.shared
    
    init() {
        let result = baseCurrencySelected
            .flatMapLatest(exchangeRateAPI.getRates(for:))
            .asObservable()
            .share()
        
        let successData = result
            .map { data -> ResultData in
                guard case .success(let value) = data else { return ResultData.empty }
               return value
            }
        
        self.selectedCurrencyRates = successData
            .map { data -> [Rate] in
                return data.rates ?? []
        }.asDriver(onErrorJustReturn: [])
        
        self.lastUpdatedTime = successData
            .map({ (data) -> String in
                let date = Date(timeIntervalSince1970: Double(data.lastUpdatedTime ?? 0))
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                dateFormatter.timeZone = .current
                return dateFormatter.string(from: date)
            }).asDriver(onErrorJustReturn: "")
    }
}
