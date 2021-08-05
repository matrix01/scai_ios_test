//
//  NetworkManager.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import Foundation
import RxSwift

protocol NetworkProtocol {
    func request<Result>(urlRequest: URLRequest,
                         type: Result.Type,
                         decoder: JSONDecoder) -> Observable<Result> where Result: Codable
}

class NetworkManager: NetworkProtocol {
    func request<Result>(urlRequest: URLRequest,
                         type: Result.Type,
                         decoder: JSONDecoder = JSONDecoder()) -> Observable<Result> where Result: Codable {
        return Observable.create { obs in
            URLSession.shared.rx.response(request: urlRequest).subscribe(
                onNext: { response in
                    #if DEBUG
                    print(response)
                    #endif
                    let response = Response(data: response.data)
                    guard let decoded = response.decode(Result.self) else {
                        obs.onError(NSError(domain: "Failed to parse data!", code: 404, userInfo: nil))
                        return
                    }
                    obs.onNext(decoded)
            },
                onError: {error in
                    obs.onError(error)
            })
        }
    }
}
