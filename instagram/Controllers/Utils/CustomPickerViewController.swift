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
                    imageView.image = image?.scalePreservingAspectRatio(targetSize: CGSize(width:self.view.frame.width, height: self.view.frame.width))
                }
            }
        }
        
    }
    
    func convertPHAssetToUIImage(asset: PHAsset, size: CGSize) -> UIImage{
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        var image = UIImage()
        
        // targetsize를 고정해두고 fetch하는것이 아니라..
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (result, _) in
            image = result!
        }
        
        return image
    }
    
    
}

extension CustomPickerViewController: UICollectionViewDelegate{
    // didSelect 비동기?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let view = self.view as! CustomPickerView
        let imageView = view.previewImageContainerView.subviews.first as! UIImageView
        
//        print("===== 변환 전 =====")
//        print(imageView.transform.a)
//        print(imageView.transform.d)
//        print("=================")
        let image = convertPHAssetToUIImage(asset: fetchResults!.object(at: indexPath.item), size: CGSize(width: view.frame.width, height: view.frame.height)).scalePreservingAspectRatio(targetSize: CGSize(width: view.frame.width, height: view.frame.height))
        
        // 이미지뷰의 frame width를 바로 적용해줘야됨
        imageView.image = image
        
        // MARK: transform 변환 문제는 비동기처리 관련 이슈였음!
        // 값 세팅은 잘되는데 main쓰레드에서 작업이 이루어지지 않는건가
        let transformTaskInit = DispatchWorkItem {
            imageView.transform.a = 1
            imageView.transform.d = 1
        }

        let transformTaskMain = DispatchWorkItem {
            var ratio: CGFloat = 0.0

            if(imageView.frame.height < view.frame.width){
                ratio = view.frame.width / imageView.frame.height

                // 이 코드가 반영이 바로 안됨
                DispatchQueue.main.async {
                    imageView.transform.a = ratio
                    imageView.transform.d = ratio
                }
            }
        }

        transformTaskInit.notify(queue: DispatchQueue.main, execute: transformTaskMain)
        DispatchQueue.main.async(execute: transformTaskInit)

//        imageView.transform.a = 1
//        imageView.transform.d = 1
//
//        var ratio: CGFloat = 0.0
//        if(imageView.frame.height < view.frame.width){
//            ratio = view.frame.width / imageView.frame.height
//
//            imageView.transform.a = ratio
//            imageView.transform.d = ratio
//        }
        
//        print("===== 변환 후 =====")
//        print(imageView.transform.a)
//        print(imageView.transform.d)
//        print("=================")
    }
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
        
        let cellImageView = UIImageView()
        
        cell.clipsToBounds = true
        cell.addSubview(cellImageView)
        
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.snp.makeConstraints {
            $0.leading.equalTo(cell.snp.leading)
            $0.top.equalTo(cell.snp.top)
            $0.bottom.equalTo(cell.snp.bottom)
            $0.trailing.equalTo(cell.snp.trailing)
        }
        
        // 이미지 해상도깨짐..
        // 여기 size 파라미터때문에 해상도가 깨짐
        cellImageView.image = convertPHAssetToUIImage(asset: fetchResults!.object(at: indexPath.item), size: CGSize(width: LayoutValues.collectionCellWidth, height: LayoutValues.collectionCellWidth )).scalePreservingAspectRatio(targetSize: CGSize(width: LayoutValues.collectionCellWidth , height: LayoutValues.collectionCellWidth ))
        return cell
    }
}

extension CustomPickerViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = otherGestureRecognizer.view as? UIImageView else {
            return true
        }
        return false
    }
}
