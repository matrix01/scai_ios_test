import Foundation
import RxCocoa
import RxSwift
import RealmSwift
import RxRealm

class TabBarViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
    }

    struct Output {
        let tabBarItems: Driver<[TabBarItem]>
    }

    override init(provider: NetworkProtocol) {
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let tabBarItems = input.trigger.asObservable().map {_ -> [TabBarItem] in
            return [.camera, .gallery]
        }.asDriver(onErrorJustReturn: [])

        return Output(tabBarItems: tabBarItems)
    }

    func viewModel(for tabBarItem: TabBarItem) -> ViewModel {
        return LandingViewModel(provider: provider)
    }
}
