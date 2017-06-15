//
//  ZoomedImageViewController.swift
//  PanoramaStitching
//
//  Created by 李茂琦 on 24/05/2017.
//  Copyright © 2017 李茂琦. All rights reserved.
//

import UIKit
import SnapKit
import Sharaku

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(showFunctions(gesture:)))
        gesture.minimumPressDuration = 1.0
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
    }
    
    @IBAction func editImage(_ sender: UIBarButtonItem) {
        let filterVC = SHViewController(image: image!)
        filterVC.delegate = self
        present(filterVC, animated: true, completion: nil)
    }
    
    private func setAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save photo to the album", style: .default) {
            [weak self] (action) in
            UIImageWriteToSavedPhotosAlbum(self!.image!, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        alert.addAction(cancleAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc private func showFunctions(gesture: UILongPressGestureRecognizer) {
        setAlert()
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

extension ZoomedImageViewController: SHViewControllerDelegate {
    func shViewControllerImageDidFilter(image: UIImage) {
        imageView.image = image
    }
    
    func shViewControllerDidCancel() {
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
