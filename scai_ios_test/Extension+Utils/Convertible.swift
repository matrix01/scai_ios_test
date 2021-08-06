//
//  Convertible.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import RxSwift
import RealmSwift

protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType
}

extension Sequence where Iterator.Element: DomainConvertibleType {
    typealias CodableElement = Iterator.Element
    func mapToDomain() -> [CodableElement.DomainType] {
        map { $0.asDomain() }
    }
}

protocol RealmRepresentable {
    associatedtype RealmType: DomainConvertibleType

    var uid: String { get }

    func asRealm() -> RealmType
}

extension Observable where Element: Sequence, Element.Iterator.Element: DomainConvertibleType {
    typealias DomainType = Element.Iterator.Element.DomainType

    func mapToDomain() -> Observable<[DomainType]> {
        return map { sequence -> [DomainType] in
            return sequence.mapToDomain()
        }
    }
}

extension Object {
    static func build<O: Object>(_ builder: (O) -> Void ) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension SortDescriptor {
    init(sortDescriptor: NSSortDescriptor) {
        self.init(keyPath: sortDescriptor.key ?? "", ascending: sortDescriptor.ascending)
    }
}
