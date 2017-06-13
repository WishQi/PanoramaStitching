//
//  ImageCollectionViewCell.swift
//  PanoramaStitching
//
//  Created by 李茂琦 on 17/05/2017.
//  Copyright © 2017 李茂琦. All rights reserved.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    public var image: UIImage? {
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
        get {
            return imageView.image
        }
    }
    
    private var imageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
    }
}
