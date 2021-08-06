//
//  PhotoCollectionViewCell.swift
//  scai_ios_test
//
//  Created by Milan Mia on 8/7/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    var viewModel: SavedPhotoModel? {
        didSet {
            imageView.image = viewModel?.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
