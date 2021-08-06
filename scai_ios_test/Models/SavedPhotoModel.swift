//
//  SavedPhotoModel.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import Realm
import RealmSwift
import RxDataSources

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

extension SavedPhotoModel {
    var image: UIImage? {
        load(fileName: id)
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = FileManager.default.getDocumentsDirectory().appendingPathComponent(id)
         
        guard let imageData = try? Data(contentsOf: fileURL) else  { return nil }
        return UIImage(data: imageData)
    }
}

extension SavedPhotoModel: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        id
    }
}

func == (rhs: SavedPhotoModel, lhs: SavedPhotoModel) -> Bool {
    rhs.id == lhs.id
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
