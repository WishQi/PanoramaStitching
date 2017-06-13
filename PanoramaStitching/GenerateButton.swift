//
//  AddCollectionViewCell.swift
//  PanoramaStitching
//
//  Created by 李茂琦 on 17/05/2017.
//  Copyright © 2017 李茂琦. All rights reserved.
//

import UIKit
import SnapKit

class GenarateButton: UIButton {
    
    private func setupView() {
        setTitle("Start Stitching", for: .normal)
        setTitleColor(UIColor.coolBlue, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 30)
        backgroundColor = UIColor.coolGray
        layer.borderColor = UIColor.coolBlue.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}
