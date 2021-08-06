import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm

class GalleryViewModel: ViewModel, ViewModelType {

    struct Input {
    }

    struct Output {
    }
    
    override init() {
        super.init()
    }

    func transform(input: Input) -> Output {
        guard let realm = try? Realm() else {
            fatalError("Unable to instantiate Realm")
        }
        return Output()
    }
}
