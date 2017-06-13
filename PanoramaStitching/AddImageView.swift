//
//  AddImageButton.swift
//  PanoramaStitching
//
//  Created by 李茂琦 on 18/05/2017.
//  Copyright © 2017 李茂琦. All rights reserved.
//

import UIKit
import SnapKit

fileprivate struct Constants {
    static let offset: CGFloat = 20
    static let lineWidth: CGFloat = 2
    static let btnWidth: CGFloat = 50
    static let lineLength: CGFloat = 25
}

extension UIColor {
    static var coolBlue: UIColor {
        get {
            return UIColor(red:0.38, green:0.49, blue:0.87, alpha:1.00)
        }
    }
    static var coolGray: UIColor {
        get {
            return UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
        }
    }
}

@objc protocol AddImageDelegate: class {
    @objc func didTouchAddButton()
}

class AddImageView: UIView {
    
    var delegate: AddImageDelegate?
    
    private var addButton = UIButton()
    private var bottomLine = UIView()
    private var verticalLine = UIView()
    private var horizontalLine = UIView()
    
    private func setupView() {
        addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(Constants.lineWidth)
        }
        bottomLine.backgroundColor = UIColor.coolBlue
        
        addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(Constants.btnWidth)
        }
        addButton.backgroundColor = UIColor.coolGray

        addButton.addSubview(verticalLine)
        verticalLine.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(Constants.lineWidth)
            make.height.equalTo(Constants.lineLength)
        }
        verticalLine.backgroundColor = UIColor.coolBlue
        
        addButton.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(Constants.lineWidth)
            make.width.equalTo(Constants.lineLength)
        }
        horizontalLine.backgroundColor = UIColor.coolBlue

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        addButton.addTarget(delegate, action: #selector(delegate?.didTouchAddButton), for: .touchUpInside)
    }

}
