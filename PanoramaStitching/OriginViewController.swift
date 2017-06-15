//
//  OriginViewController.swift
//  PanoramaStitching
//
//  Created by 李茂琦 on 17/05/2017.
//  Copyright © 2017 李茂琦. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

fileprivate let reuseIdentifier = "ImageCell"

class OriginViewController: UIViewController {
    
    var selectedAssets = [TLPHAsset]() {
        didSet {
            imageCollectionView.reloadData()
            print("reload data")
        }
    }
    
    var stitchedImage: UIImage?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var generateButton: GenarateButton! {
        didSet {
            generateButton.addTarget(self, action: #selector(stitchImages), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.delegate = self
            imageCollectionView.dataSource = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ImageCollectionViewCell {
            if let zoomedVC = segue.destination as? ZoomedImageViewController {
                zoomedVC.image = cell.image
                return
            }
        }
        guard let stitchedImg = stitchedImage else {
            print("There are no images to stitch.")
            return
        }
        if let _ = sender as? GenarateButton {
            if let zoomedVC = segue.destination as? ZoomedImageViewController {
                zoomedVC.image = stitchedImg
            }
        }
    }
    
    @objc private func stitchImages() {
        guard !selectedAssets.isEmpty else { return }
        var originalImages = [UIImage]()
        for photo in selectedAssets {
            originalImages.append(photo.fullResolutionImage!)
        }
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let resultImage = OpenCVWrapper.process(with: originalImages) {
                self?.stitchedImage = resultImage
            } else {
                let alertVC = UIAlertController(title: "Error!", message: "Cannot stitch the selected images!", preferredStyle: .alert)
                let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertVC.addAction(cancleAction)
                self?.present(alertVC, animated: true, completion: nil)
            }
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.performSegue(withIdentifier: "show", sender: self?.generateButton)
            }
        }
    }

}

extension OriginViewController: AddImageDelegate {
    func didTouchAddButton() {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 10
        configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main)
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        self.present(viewController, animated: true, completion: nil)
    }
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}

extension OriginViewController: TLPhotosPickerViewControllerDelegate {
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
    }
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        // if you want to used phasset.
    }
    func photoPickerDidCancel() {
        // cancel
    }
    func dismissComplete() {
        // picker dismiss completion
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        self.showAlert(vc: picker)
    }
}

extension OriginViewController: UICollectionViewDelegate {
    
}

extension OriginViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.image = selectedAssets[indexPath.row].fullResolutionImage
        
        return cell
    }
}

fileprivate struct Constants {
    static let itemsPerRow: CGFloat = 2
    static let padding: CGFloat = 20
}

extension OriginViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.padding * (Constants.itemsPerRow + 1)
        let widthPerItem = (view.frame.width - paddingSpace) / Constants.itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
