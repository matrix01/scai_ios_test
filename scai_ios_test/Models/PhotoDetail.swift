//
//  PhotoDetail.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation

// MARK: - PhotoDetailValue
struct PhotoDetailValue: Codable {
    let barcode, photoDetailDescription, id: String
    let imageURL: String
    let name: String
    let retailPrice: Int
    let costPrice: Int?

    enum CodingKeys: String, CodingKey {
        case barcode
        case photoDetailDescription = "description"
        case id
        case imageURL = "image_url"
        case name
        case retailPrice = "retail_price"
        case costPrice = "cost_price"
    }
}

typealias PhotoDetail = [String: PhotoDetailValue]
