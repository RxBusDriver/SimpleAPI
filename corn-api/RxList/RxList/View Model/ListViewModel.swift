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
    func fetchCityList() -> Observable<[City]> {
        guard let url = URL(string: "https://v2-api.sheety.co/3024f89b7efb7859d2899a6955922af7/cityList/cities") else { return Observable.empty() }
        return URLSession.shared.rx.response(request: URLRequest(url: url)).map { response, data in
            if 200..<300 ~= response.statusCode {
                guard let cityResponse = try? JSONDecoder().decode(CityResponse.self, from: data) else { throw ParseError.decodingError }
                return cityResponse.cities
            }
            
            throw NetworkError.pageNotFound
        }
    }
}
