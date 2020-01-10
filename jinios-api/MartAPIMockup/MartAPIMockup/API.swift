//
//  API.swift
//  MartAPIMockup
//
//  Created by zella.ddo on 2019/12/31.
//  Copyright © 2019 zella.ddo. All rights reserved.
//

import Foundation
import RxSwift

class DataSetter {
    
    static func request<T: Codable>(_ type: T.Type, url: URL) -> Observable<T> {
        
        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: configure)
        
        return Observable<T>.create { observer in
            let sessionTask = session.dataTask(with: url) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                    do {
                        let branches = try JSONDecoder().decode(T.self, from: data, keyPath: "data")
                        observer.onNext(branches)
                    } catch {
                        observer.onError(error)
                    }
                } else {
                    observer.onError(error!)
                }
            }
            sessionTask.resume()
            
            return Disposables.create {
                sessionTask.cancel()
            }
        }
    }
    
    // 예전꺼
    static func request(url: URL?, handler: @escaping(() -> ())) {
        guard let url = url else { return }

        let configure = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 15
        let session = URLSession(configuration: configure)
        
        session.dataTask(with: url) { (data, response, error) in

            var branches = [BranchRawData]()
            
            if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, let data = data {
                do {
                    branches = try JSONDecoder().decode([BranchRawData].self, from: data) as! [BranchRawData]
                    handler()
                } catch {
                    handler()
                }
            } else {
                handler()
            }
        }.resume()
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}
