import UIKit
import RxSwift
import RxCocoa
import RxGesture
import NSObject_Rx
import RxDataSources

class GalleryViewController: ViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        title = "Gallery"
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseID)
        
        let newBackButton = UIBarButtonItem(title: "Back",
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(GalleryViewController.back(sender:)))
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc private func back(sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel as? GalleryViewModel else { return }
        let willAppear = rx.viewWillAppear.mapToVoid().asDriverOnErrorJustComplete()
        
        let input = GalleryViewModel.Input(trigger: willAppear)
        let output = viewModel.transform(input: input)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<PhotoSectionModel>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseID, for: indexPath)
                guard let photoCell = cell as? PhotoCollectionViewCell else { return cell }
                photoCell.viewModel = item
                return photoCell
            })
        
        output.dataSource
            .map{ [$0] }
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.itemSelected
            .map { indexPath -> SavedPhotoModel? in
                guard let models = dataSource.sectionModels.first?.items else {
                    return nil
                }
                return models[indexPath.row]
            }
            .asObservable()
            .filterNil()
            .asDriverOnErrorJustComplete()
            .drive(rx.showClothDetail)
            .disposed(by: rx.disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: rx.disposeBag)
    }
}

fileprivate extension Reactive where Base: GalleryViewController {
    var showClothDetail: Binder<SavedPhotoModel> {
        Binder(self.base) {base, photoModel in
            guard let provider = Application.shared.provider else { return }
            let detailModel = DetailViewModel(provider: provider, photoModel: photoModel)
            base.navigator?.show(segue: .detail(viewModel: detailModel), sender: base)
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fullWidth: CGFloat = CGFloat(self.view.width) - CGFloat( 8.0 * 3.0 )
        let cellWidth: CGFloat = fullWidth / 2.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}

struct PhotoSectionModel {
    var header: String
    var items: [SavedPhotoModel]
}

extension PhotoSectionModel: AnimatableSectionModelType, IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        return header
    }
    
    init(original: PhotoSectionModel, items: [SavedPhotoModel]) {
        self = original
        self.items = items
    }
}
