//
//  UIImagePickerController+Rx.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/5/21.
//

import AVFoundation
import Foundation
import MobileCoreServices
import RxSwift
import UIKit

enum RxMediaPickerAction {
    case photo(observer: AnyObserver<(UIImage, UIImage?)>)
}

public enum RxMediaPickerError: Error {
    case generalError
    case canceled
}

public protocol RxMediaPickerDelegate: class {
    func present(picker: UIImagePickerController)
    func dismiss(picker: UIImagePickerController)
}

@objc open class RxMediaPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: RxMediaPickerDelegate?

    fileprivate var currentAction: RxMediaPickerAction?

    open var deviceHasCamera: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    public init(delegate: RxMediaPickerDelegate) {
        self.delegate = delegate
    }

    open func takePhoto(device: UIImagePickerController.CameraDevice = .rear,
                        flashMode: UIImagePickerController.CameraFlashMode = .auto,
                        editable: Bool = false) -> Observable<(UIImage, UIImage?)> {
        return Observable.create { [unowned self] observer in
            self.currentAction = RxMediaPickerAction.photo(observer: observer)

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = editable
            picker.delegate = self

            if UIImagePickerController.isCameraDeviceAvailable(device) {
                picker.cameraDevice = device
            }

            if UIImagePickerController.isFlashAvailable(for: picker.cameraDevice) {
                picker.cameraFlashMode = flashMode
            }

            self.present(picker)

            return Disposables.create()
        }
    }

    open func selectImage(source: UIImagePickerController.SourceType = .photoLibrary,
                          editable: Bool = false) -> Observable<(UIImage, UIImage?)> {
        return Observable.create { [unowned self] observer in
            self.currentAction = RxMediaPickerAction.photo(observer: observer)

            let picker = UIImagePickerController()
            picker.sourceType = source
            picker.allowsEditing = editable
            picker.delegate = self

            self.present(picker)

            return Disposables.create()
        }
    }

    func processPhoto(info: [UIImagePickerController.InfoKey: Any],
                      observer: AnyObserver<(UIImage, UIImage?)>) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            observer.on(.error(RxMediaPickerError.generalError))
            return
        }

        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        observer.onNext((image, editedImage))
        observer.onCompleted()
    }

    fileprivate func present(_ picker: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.present(picker: picker)
        }
    }

    fileprivate func dismiss(_ picker: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.dismiss(picker: picker)
        }
    }

    // MARK: UIImagePickerControllerDelegate
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let action = currentAction {
            switch action {
            case .photo(let observer):
                processPhoto(info: info, observer: observer)
                dismiss(picker)
            }
        }
    }

    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(picker)

        if let action = currentAction {
            switch action {
            case .photo(let observer): observer.on(.error(RxMediaPickerError.canceled))
            }
        }
    }
}
