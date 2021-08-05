//
//  NetworkMock.swift
//  scai_ios_testTests
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import RxSwift
@testable import scai_ios_test

class NetworkManagerMock: NetworkProtocol {
    func request<Result>(urlRequest: URLRequest,
                         type: Result.Type,
                         decoder: JSONDecoder = JSONDecoder()) -> Observable<Result> where Result: Codable {
        return Observable.create { obs in
            
            if let topModel: Result = MockDataCreator.decode(fileName: "photo_detail") {
                obs.onNext(topModel)
            } else {
                obs.onError(NSError(domain: "Failed to parse data!", code: 404, userInfo: nil))
            }
            return Disposables.create()
        }
    }
}
