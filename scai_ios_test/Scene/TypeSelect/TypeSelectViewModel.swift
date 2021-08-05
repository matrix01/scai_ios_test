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
        let datasourceProvider: Driver<[String]>
    }
    
    private var previewImage: UIImage?
    fileprivate let titleRelay = BehaviorRelay<[String]?>(value: nil)
    
    init(provider: NetworkProtocol, image: UIImage) {
        super.init(provider: provider)
        previewImage = image
    }

    func transform(input: Input) -> Output {
        let imageRelay = BehaviorRelay<UIImage?>(value: nil)
        
        input.trigger.asObservable()
            .map{[weak self] in self?.previewImage }
            .bind(to: imageRelay)
            .disposed(by: rx.disposeBag)
        
        input.trigger.asObservable()
            .bind(to: rx.loadList)
            .disposed(by: rx.disposeBag)
        
        return Output(imageProvider: imageRelay.asDriver(),
                      datasourceProvider: titleRelay.asObservable().filterNil().asDriver(onErrorJustReturn: []))
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
                this.titleRelay.accept(list.map{ $0.value.name })
            }, onError: {[weak self] error in
                guard let this = self else { return }
                this.isFetching.accept(false)
                this.errorTracker.accept(error)
            }).disposed(by: rx.disposeBag)
    }
}
