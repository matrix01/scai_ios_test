//
//  Object+Ext.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import RealmSwift

extension Object {
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self, update: .modified)
            }
        } catch {
            print("Failed to save realm data")
        }
    }
}
