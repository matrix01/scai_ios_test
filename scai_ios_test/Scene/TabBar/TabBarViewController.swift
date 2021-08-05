import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx

enum TabBarItem: Int {
    case camera, gallery

    private func controller(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        if let viewController = StoryboardName.landing.viewController as? LandingViewController {
            viewController.setup(viewModel: viewModel, navigator: navigator)
            return viewController
        }
        return UIViewController()
    }

    var image: UIImage? {
        switch self {
        case .camera: return UIImage(systemName: "camera")
        case .gallery: return UIImage(systemName: "list.and.film")
        }
    }

    var title: String {
        switch self {
        case .camera: return "Camera"
        case .gallery: return "Gallery"
        }
    }

    var tintColor: UIColor? {
        return UIColor.orange
    }

    func getController(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        let vc = controller(with: viewModel, navigator: navigator)
        let item = UITabBarItem(title: title, image: image, tag: rawValue)
        vc.tabBarItem = item
        return vc
    }
}

class TabBarViewController: UITabBarController, Navigatable {

    var viewModel: TabBarViewModel?
    var navigator: Navigator?

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
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        bindViewModel()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedItem = tabBar.items?.firstIndex(of: item) else { return }
        let tabBarMenuItem = TabBarItem(rawValue: selectedItem)
        tabBar.tintColor = tabBarMenuItem?.tintColor
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
