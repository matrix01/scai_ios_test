import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx

class TypeSelectViewController: ViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel as? TypeSelectViewModel else { return }
        let willAppear = rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete()
        let saveTrigger = saveButton.rx.tapGesture()
            .withLatestFrom(pickerView.rx.itemSelected)
            .map{ $0.row }
            .asDriverOnErrorJustComplete()
        
        let input = TypeSelectViewModel.Input(trigger: willAppear, saveTrigger: saveTrigger)
        let output = viewModel.transform(input: input)
        
        output.imageProvider
            .drive(imageView.rx.image)
            .disposed(by: rx.disposeBag)
        
        output.datasourceProvider
            .asObservable()
            .bind(to: pickerView.rx.itemTitles) { $1 }
            .disposed(by: rx.disposeBag)
    }
}
