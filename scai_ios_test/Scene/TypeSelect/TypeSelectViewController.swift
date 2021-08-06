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
        
        let initialValue = BehaviorRelay<Int>(value: 0)
        let combined = Observable.merge([pickerView.rx.itemSelected.map{ $0.row }, initialValue.skip(1).asObservable()])
        
        let saveTrigger = saveButton.rx.tapGesture()
            .withLatestFrom(combined)
            .map{ $0 }
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
        
        output.datasourceProvider
            .map { $0.count }
            .drive {[weak self] count in
                self?.pickerView.selectRow(count/2, inComponent: 0, animated: true)
                initialValue.accept(0)
            }
            .disposed(by: rx.disposeBag)

        
    }
}
