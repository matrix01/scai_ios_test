import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm
import UIKit

class TypeSelectViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let saveTrigger: Driver<Int>
    }

    struct Output {
        let imageProvider: Driver<UIImage?>
        let datasourceProvider: Driver<[String]>
    }
    
    private var previewImage: UIImage?
    fileprivate let titleRelay = BehaviorRelay<[String]?>(value: nil)
    
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
        
        input.trigger.asObservable()
            .bind(to: rx.loadList)
            .disposed(by: rx.disposeBag)
        
        let rmDetailList = realm.objects(RMPhotoDetailValue.self)

        Observable.changeset(from: rmDetailList)
            .map { $0.0.mapToDomain() }
            .map { $0.map { $0.name } }
            .bind(to: titleRelay)
            .disposed(by: rx.disposeBag)
        
        Observable.combineLatest(input.saveTrigger.asObservable(), titleRelay)
            .subscribe {[weak self] (row, titles) in
                if let title = titles?[row],
                   let localImageName = self?.previewImage?.saveImage() {
                    
                    //Save a resized image and store in database
                    let savedPhotoModel = SavedPhotoModel(id: localImageName, typeModelName: title)
                    savedPhotoModel.asRealm().save()
                    print(savedPhotoModel)
                }
            }
            .disposed(by: rx.disposeBag)
        
        let titleProvider = titleRelay
            .asObservable()
            .filterNil()
            .asDriver(onErrorJustReturn: [])
        
        return Output(imageProvider: imageRelay.asDriver(),
                      datasourceProvider: titleProvider)
    }
}

fileprivate extension Reactive where Base: TypeSelectViewModel {
    var loadList: Binder<Void> {
        Binder(self.base) { base, _ in
            base.loadDetailListAndSaveToRealm()
        }
    }
}

fileprivate extension TypeSelectViewModel {
    // Fetch available photodetail list
    func loadDetailListAndSaveToRealm() {
        guard let request = ApiRequest.detailList.request else {
            errorTracker.accept(.none)
            return
        }
        isFetching.accept(true)
        provider.request(urlRequest: request, type: PhotoDetail.self, decoder: JSONDecoder())
            .subscribe(onNext: { [weak self] list in
                guard let this = self else { return }
                this.isFetching.accept(false)
                list.forEach { $1.asRealm().save() }
            }, onError: {[weak self] error in
                guard let this = self else { return }
                this.isFetching.accept(false)
                this.errorTracker.accept(error)
            }).disposed(by: rx.disposeBag)
    }
}
