//
//  RMPhotoDetail.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import Realm
import RealmSwift

// MARK: - RMPhotoDetailValue
class RMPhotoDetailValue: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var barcode: String = ""
    @objc dynamic var photoDetailDescription: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var retailPrice: Int = 0
    @objc dynamic var costPrice: Int = 0
    
    override class func primaryKey() -> String? {
        return #keyPath(name)
    }
}

// MARK: - RMPhotoDetailValue -> PhotoDetailValue
extension RMPhotoDetailValue: DomainConvertibleType {
    func asDomain() -> PhotoDetailValue {
        return PhotoDetailValue(id: id,
                                barcode: barcode,
                                photoDescription: photoDetailDescription,
                                imageURL: imageURL,
                                name: name,
                                retailPrice: retailPrice,
                                costPrice: costPrice)
    }
}
