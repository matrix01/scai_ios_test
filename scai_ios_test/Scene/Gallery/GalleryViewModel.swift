import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm

class GalleryViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
    }

    struct Output {
        let dataSource: Driver<PhotoSectionModel>
    }
    
    func transform(input: Input) -> Output {
        guard let realm = try? Realm() else {
            fatalError("Unable to instantiate Realm")
        }
        
        let rmPhotoList = realm.objects(RMSavedPhotoModel.self)
        let dataSourceRelay = BehaviorRelay<PhotoSectionModel?>(value: nil)
        
        Observable.changeset(from: rmPhotoList)
            .map { $0.0.mapToDomain() }
            .map { PhotoSectionModel(header: "", items: $0) }
            .bind(to: dataSourceRelay)
            .disposed(by: rx.disposeBag)

        return Output(dataSource: dataSourceRelay.asObservable().filterNil().asDriverOnErrorJustComplete())
    }
}
