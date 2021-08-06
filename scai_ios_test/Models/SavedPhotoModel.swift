//
//  SavedPhotoModel.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import Realm
import RealmSwift

// MARK:- SavedPhotoModel
struct SavedPhotoModel: Codable {
    let id: String
    let typeModelName: String
    
    init(id: String, typeModelName: String) {
        self.id = id
        self.typeModelName = typeModelName
    }
}

extension SavedPhotoModel: RealmRepresentable {
    var uid: String {
        id
    }
    func asRealm() -> RMSavedPhotoModel {
        RMSavedPhotoModel.build { object in
            object.id = id
            object.typeModelName = typeModelName
        }
    }
}

// MARK:- Realm RMSavedPhotoModel
class RMSavedPhotoModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var typeModelName: String = ""
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
}

extension RMSavedPhotoModel: DomainConvertibleType {
    func asDomain() -> SavedPhotoModel {
        return SavedPhotoModel(id: id, typeModelName: typeModelName)
    }
}
