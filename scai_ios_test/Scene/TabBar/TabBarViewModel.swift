import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm

class TabBarViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let showGalleryTrigger: Driver<Bool>
    }

    struct Output {
        let tabBarItems: Driver<[TabBarItem]>
        let showGalleryTrigger: Driver<GalleryViewModel>
    }

    override init(provider: NetworkProtocol) {
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let tabBarItems = input.trigger.asObservable().map {_ -> [TabBarItem] in
            return [.camera, .gallery]
        }.asDriver(onErrorJustReturn: [])

        let galleryTrigger = input.showGalleryTrigger
            .filter { $0 == true }
            .map {[weak self] _ -> GalleryViewModel? in
                guard let provider = self?.provider else {
                    return nil
                }
                return GalleryViewModel(provider: provider)
            }
            .compactMap{ $0 }
            .asDriver()
        
        return Output(tabBarItems: tabBarItems,
                      showGalleryTrigger: galleryTrigger)
    }

    func viewModel(for tabBarItem: TabBarItem) -> ViewModel {
        return LandingViewModel(provider: provider)
    }
}
