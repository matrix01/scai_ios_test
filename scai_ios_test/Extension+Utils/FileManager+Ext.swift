//
//  FileManager+Ext.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/6/21.
//

import Foundation
import UIKit

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func saveImage() -> String? {
        let resizedImage = self.resizeImage(targetSize: CGSize(width: 300, height: 400))
        if let data = resizedImage?.pngData() {
            let imageName = "\(UUID().uuidString).jpg"
            let filename = FileManager.default.getDocumentsDirectory().appendingPathComponent(imageName)
            try? data.write(to: filename)
            return imageName
        }
        return nil
    }
}

