//
//  ZoomedImageViewController.swift
//  PanoramaStitching
//
//  Created by 李茂琦 on 24/05/2017.
//  Copyright © 2017 李茂琦. All rights reserved.
//

import UIKit
import SnapKit

class ZoomedImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    fileprivate var imageView = UIImageView()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        updateConstraintsForSize(size: view.frame.size)
    }
    
    func updateConstraintsForSize(size: CGSize) {
        
        print("update")
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        
        print(xOffset, yOffset)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(yOffset)
            make.bottom.equalToSuperview().offset(yOffset)
            make.leading.equalToSuperview().offset(xOffset)
            make.trailing.equalToSuperview().offset(xOffset)
        }
        
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMinZoomScaleForSize(size: view.bounds.size)
    }
    
}

extension ZoomedImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateConstraintsForSize(size: view.frame.size)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(size: view.frame.size)
    }
}
