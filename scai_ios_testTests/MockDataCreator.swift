//
//  MockDataCreator.swift
//  scai_ios_testTests
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation

class MockDataCreator {
    class func loadJSON(fileName: String) -> Data? {
        guard let path = Bundle(for: MockDataCreator.self).url(forResource: fileName,
                                                               withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: path)
    }
    
    class func decode<T: Decodable>(fileName: String) -> T? {
        guard let data = loadJSON(fileName: fileName) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
