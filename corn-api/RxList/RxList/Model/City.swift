//
//  City.swift
//  RxList
//
//  Created by 이동건 on 2020/01/10.
//  Copyright © 2020 이동건. All rights reserved.
//

import Foundation

struct CityResponse: Decodable {
    var cities: [City]
}

struct City: Decodable {
    var id: Int
    var country: String
    var city: String
}
