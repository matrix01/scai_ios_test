//
//  Reusable.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import UIKit

protocol Reusable {
    static var reuseID: String { get }
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable { /* empty */ }

extension UICollectionView: Reusable {
    func dequeueReusableCell<T: Reusable>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
            fatalError("Failed to initialize cell")
        }
        return cell
    }
}
