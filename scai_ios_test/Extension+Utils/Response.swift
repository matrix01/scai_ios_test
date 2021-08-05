//
//  Response.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import Foundation

struct Response {
    fileprivate var data: Data
    init(data: Data) {
        self.data = data
    }
}

struct CustomError: Decodable {
    let code: Int
    let description: String
}

extension Response {
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            return response
        } catch let error {
            return CustomError(code: 404, description: error.localizedDescription) as? T
        }
    }
}
