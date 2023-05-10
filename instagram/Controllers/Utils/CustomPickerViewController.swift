//
//  CustomPickerViewController.swift
//  instagram
//
//  Created by Jun on 2023/05/10.
//

import UIKit
import Photos

class CustomPickerViewController: UIViewController {
    
    var fetchResults:PHFetchResult<PHAsset>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customView = CustomPickerView()
        customView.backgroundColor = .defaultNavigationColor
        self.view = customView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPhotos()
    }
    
    func setupPhotos(){
        fetchResults = fetchPhotos()
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.isSynchronous = true
        
        if let asset = fetchResults?.firstObject{
            imageManager.requestImage(for: asset, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.width), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                
                
                let customPickerView = self.view as! CustomPickerView
                let imageView = customPickerView.previewImageContainerView.subviews.first as! UIImageView
                
                // 핀치 이벤트 등록
                // scale은 고정하되 이미지가 다른 영역을 침범하지 않아야함
                // 1. containerView height값이 바뀌는지
                imageView.enableZoom()
                
                
                DispatchQueue.main.async {
                    imageView.image = image?.scalePreservingAspectRatio(targetSize: CGSize(width:self.view.frame.width, height: self.view.frame.width), autoResize: false)
                    
                }
                
            }
        }
        
    }
    
    
}

extension CustomPickerViewController: UICollectionViewDelegate{
    
}

extension CustomPickerViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath)
        
        return cell
    }
}

extension CustomPickerViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.width / 4)
    }
}
