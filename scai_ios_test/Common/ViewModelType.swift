//
//  ViewModelType.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {

    let provider: NetworkProtocol
    var isFetching = BehaviorRelay<Bool>(value: false)
    let errorTracker = BehaviorRelay<Error?>(value: nil)

    init(provider: NetworkProtocol) {
        self.provider = provider
        super.init()
    }

    func eraseToViewModel() -> ViewModel {
        self as ViewModel
    }
}
