import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm
import UIKit

class DetailViewModel: ViewModel, ViewModelType {

    struct Input {
        let imageUrlTap: Driver<Void>
    }

    struct Output {
        let imageProvider: Driver<UIImage?>
        let photoModel: Driver<PhotoDetailValue>
        let openUrl: Driver<URL?>
    }

    private var photoModel: SavedPhotoModel?
    
    init(provider: NetworkProtocol, photoModel: SavedPhotoModel) {
        super.init(provider: provider)
        self.photoModel = photoModel
    }
    
    func transform(input: Input) -> Output {
        guard let realm = try? Realm() else {
            fatalError("Unable to instantiate Realm")
        }
        
        let imageRelay = BehaviorRelay<UIImage?>(value: nil)
        let photoModelRelay = BehaviorRelay<PhotoDetailValue?>(value: nil)
        
        let photoDetailModel = realm.object(ofType: RMPhotoDetailValue.self, forPrimaryKey: photoModel?.typeModelName)
        
        photoModelRelay.accept(photoDetailModel?.asDomain())
        imageRelay.accept(photoModel?.image)
        
        let detailModelProvider = photoModelRelay.asObservable()
            .filterNil()
            .asDriverOnErrorJustComplete()
        
        let imageURLProvider = input.imageUrlTap.skip(1)
            .withLatestFrom(detailModelProvider)
            .map{ URL(string: $0.imageURL) }
        
        return Output(imageProvider: imageRelay.asDriver(),
                      photoModel: detailModelProvider,
                      openUrl: imageURLProvider)
    }
}
