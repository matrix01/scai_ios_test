import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx

class DetailViewController: ViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageURLButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var retailPriceLabel: UILabel!
    @IBOutlet private weak var barcodeLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel as? DetailViewModel else { return }
        let buttonTap = imageURLButton.rx.tapGesture()
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = DetailViewModel.Input(imageUrlTap: buttonTap)
        let output = viewModel.transform(input: input)
        
        output.imageProvider
            .drive(imageView.rx.image)
            .disposed(by: rx.disposeBag)
        
        output.photoModel
            .map { $0.name }
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.photoModel
            .map { $0.photoDetailDescription }
            .map({ string -> NSAttributedString in
                let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.blue]
                let attributedString = NSAttributedString(string: string, attributes: attributedStringColor)
                return attributedString
            })
            .drive(descriptionLabel.rx.attributedText)
            .disposed(by: rx.disposeBag)
        
        output.photoModel
            .map { $0.name }
            .drive(nameLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.photoModel
            .map { "Barcode: \($0.barcode)" }
            .drive(barcodeLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.photoModel
            .map { "ID: \($0.id)" }
            .drive(idLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.photoModel
            .map { "Price: \($0.retailPrice)" }
            .drive(retailPriceLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        output.openUrl
            .drive(rx.openURL)
            .disposed(by: rx.disposeBag)
    }
    
    
    private func setupView() {
        title = "Detail"
    }
}

fileprivate extension Reactive where Base: DetailViewController {
    var openURL: Binder<URL?> {
        Binder(self.base) {base, photoURL in
            guard let url = photoURL else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
