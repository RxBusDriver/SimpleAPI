//
//  ListViewModel.swift
//  RxList
//
//  Created by 이동건 on 2020/01/10.
//  Copyright © 2020 이동건. All rights reserved.
//

import Foundation
import RxSwift

enum NetworkError: Error {
    case pageNotFound
}

enum ParseError: Error {
    case encodingError
    case decodingError
}

class ListViewModel {
    private var isLoadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var isLoading: Observable<Bool> { return isLoadingSubject.asObservable() }
    
    func fetchCityList() -> Observable<[City]> {
        guard let url = URL(string: "https://v2-api.sheety.co/3024f89b7efb7859d2899a6955922af7/cityList/cities") else { return Observable.empty() }

        isLoadingSubject.onNext(true)
        return URLSession.shared.rx.response(request: URLRequest(url: url)).map { [weak self] response, data in
            if 200..<300 ~= response.statusCode {
                guard let cityResponse = try? JSONDecoder().decode(CityResponse.self, from: data) else {
                    self?.isLoadingSubject.onNext(false)
                    throw ParseError.decodingError
                }
                self?.isLoadingSubject.onNext(false)
                return cityResponse.cities
            }

            self?.isLoadingSubject.onNext(false)
            throw NetworkError.pageNotFound
        }
    }
}
