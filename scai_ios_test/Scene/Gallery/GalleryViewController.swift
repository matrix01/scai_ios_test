import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx

class GalleryViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

fileprivate extension Reactive where Base: GalleryViewController {
    var someBinder: Binder<Void> {
        Binder(self.base) {base, _ in
        }
    }
}
