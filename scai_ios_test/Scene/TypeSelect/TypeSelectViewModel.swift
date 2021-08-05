import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm
import UIKit

class TypeSelectViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
    }

    struct Output {
        let imageProvider: Driver<UIImage?>
    }
    
    private var previewImage: UIImage?
    
    init(provider: NetworkProtocol, image: UIImage) {
        super.init(provider: provider)
        previewImage = image
    }

    func transform(input: Input) -> Output {
        guard let realm = try? Realm() else {
            fatalError("Unable to instantiate Realm")
        }
        
        let imageRelay = BehaviorRelay<UIImage?>(value: nil)
        
        input.trigger.asObservable()
            .map{[weak self] in self?.previewImage }
            .bind(to: imageRelay)
            .disposed(by: rx.disposeBag)
        
        return Output(imageProvider: imageRelay.asDriver())
    }
}
