//
//  CustomPickerViewController.swift
//  instagram
//
//  Created by Jun on 2023/05/10.
//

import UIKit
import Photos

class CustomPickerViewController: UIViewController {
    
    var fetchResults:PHFetchResult<PHAsset>?{
        didSet{
            let view = self.view as! CustomPickerView
            let collectionView = view.collectionView
            
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customView = CustomPickerView()
        customView.backgroundColor = .defaultNavigationColor
        self.view = customView
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupThumbnailPhotos()
    }
    
    func setupThumbnailPhotos(){
        fetchResults = fetchPhotos()
        
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.isSynchronous = true
        
        if let asset = fetchResults?.firstObject{
            imageManager.requestImage(for: asset, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.width), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                
                
                let customPickerView = self.view as! CustomPickerView
                let imageView = customPickerView.previewImageContainerView.subviews.first as! UIImageView
                
                // 핀치 이벤트 등록
                // scale은 고정하되 이미지가 다른 영역을 침범하지 않아야함 - clipsToBounds처리
                imageView.enableZoom()
                imageView.enableDrag()
                
                
                DispatchQueue.main.async {
                    imageView.image = image?.scalePreservingAspectRatio(targetSize: CGSize(width:self.view.frame.width, height: self.view.frame.width), autoResize: false)
                    
                }
                
            }
        }
        
    }
    
    func convertPHAssetToUIImage(asset: PHAsset, size: CGSize) -> UIImage{
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var image = UIImage()
        
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option) { (result, _) in
            image = result!
        }
        
        return image
    }
    
    
}

extension CustomPickerViewController: UICollectionViewDelegate{
    
}

extension CustomPickerViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fetchResults?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath)
        
        let imageView = UIImageView()
        
        cell.backgroundColor = .green
        cell.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.leading.equalTo(cell.snp.leading)
            $0.top.equalTo(cell.snp.top)
            $0.bottom.equalTo(cell.snp.bottom)
            $0.trailing.equalTo(cell.snp.trailing)
        }
        
        imageView.image = convertPHAssetToUIImage(asset: fetchResults!.object(at: indexPath.item), size: CGSize(width: LayoutValues.collectionCellWidth, height: LayoutValues.collectionCellWidth))
        
        return cell
    }
}

extension CustomPickerViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
