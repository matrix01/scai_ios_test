import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx

class TabBarViewController: UITabBarController, Navigatable, RxMediaPickerDelegate {

    var viewModel: TabBarViewModel?
    var navigator: Navigator?
    var picker: RxMediaPicker!

    init(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel as? TabBarViewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedItem = tabBar.items?.firstIndex(of: item) else { return }
        let tabBarMenuItem = TabBarItem(rawValue: selectedItem)
        tabBar.tintColor = tabBarMenuItem?.tintColor
        
        switch item.title {
        case "Camera":
            self.takePhoto()
        default:
            break
        }
    }
    
    /// setup tab bar veiw controllers
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        let willAppear = rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete()
        
        let input = TabBarViewModel.Input(trigger: willAppear)
        let output = viewModel.transform(input: input)

        output.tabBarItems.drive(onNext: { [weak self] tabBarItems in
            if let strongSelf = self, let navigator = strongSelf.navigator {
                let controllers = tabBarItems.map { $0.getController(with: viewModel.viewModel(for: $0), navigator: navigator) }
                strongSelf.setViewControllers(controllers, animated: false)
            }
        }).disposed(by: rx.disposeBag)
        
        picker = RxMediaPicker(delegate: self)
    }
    
    fileprivate func takePhoto() {
        picker.selectImage()
            .observe(on: MainScheduler.instance)
            .catch({ error -> Observable<(UIImage, UIImage?)> in
                .empty()
            })
            .map {$0.0}
            .bind(to: rx.showImagePreview)
            .disposed(by: rx.disposeBag)

    }

}

fileprivate extension Reactive where Base: TabBarViewController {
    var showImagePreview: Binder<UIImage> {
        Binder(self.base) {base, image in
            guard let provider = Application.shared.provider else { return }
            let viewModel = TypeSelectViewModel(provider: provider, image: image)
            base.navigator?.show(segue: .typeSelect(viewModel: viewModel), sender: base)
        }
    }
}

extension RxMediaPickerDelegate where Self: TabBarViewController {
    // RxMediaPickerDelegate
    func present(picker: UIImagePickerController) {
        print("Will present picker")
        present(picker, animated: true, completion: nil)
    }
    
    func dismiss(picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
