//
//  PhotoDetail.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import Realm
import RealmSwift

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
    
    init(id: String,
         barcode: String,
         photoDescription: String,
         imageURL: String,
         name: String,
         retailPrice: Int,
         costPrice: Int) {
        self.id = id
        self.barcode = barcode
        self.photoDetailDescription = photoDescription
        self.imageURL = imageURL
        self.retailPrice = retailPrice
        self.costPrice = costPrice
        self.name = name
    }
}

typealias PhotoDetail = [String: PhotoDetailValue]

extension PhotoDetailValue: RealmRepresentable {
    var uid: String {
        id
    }
    func asRealm() -> RMPhotoDetailValue {
        RMPhotoDetailValue.build { object in
            object.id = id
            object.barcode = barcode
            object.photoDetailDescription = photoDetailDescription
            object.imageURL = imageURL
            object.name = name
            object.retailPrice = retailPrice
            object.costPrice = costPrice ?? 0
        }
    }
}
