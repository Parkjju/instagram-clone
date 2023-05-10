//
//  CustomPickerView.swift
//  instagram
//
//  Created by Jun on 2023/05/10.
//

import UIKit
import Photos

class CustomPickerView: UIView {
    
    // MARK: UI 컴포넌트들 정의
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "photo")
        return cv
    }()
    
    let navBar: UINavigationBar = {
        let bar = UINavigationBar()
        // 네비게이션 바 타이틀 설정
        let navItem = UINavigationItem(title: "라이브러리")
        
        let leftBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleBackButtonTapped))
        let rightBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(handleCompletionButtonTapped))
        
        navItem.leftBarButtonItem = leftBarButton
        navItem.rightBarButtonItem = rightBarButton
        bar.setItems([navItem], animated: false)
        
        return bar
    }()
    
    let previewImageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        
        let preImageView = UIImageView()
        view.addSubview(preImageView)
        
        preImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        view.clipsToBounds = true
        
        return view
    }()
    
    // MARK: 디폴트 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: UI관련 코드 - Layout / CollectionView setup
    
    // UIView lifecycle method - last calling method
    override func didMoveToSuperview() {
        setupCollectionView()
        layoutViews()
    }
    
    func layoutViews(){
        self.addSubview(navBar)
        self.addSubview(previewImageContainerView)
        self.addSubview(collectionView)
        
        
        navBar.anchor(top: self.safeAreaLayoutGuide.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
        previewImageContainerView.anchor(top: navBar.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: self.frame.width)
        collectionView.anchor(top: previewImageContainerView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    func setupCollectionView(){
        guard let customPickerVC = self.parentViewController as? CustomPickerViewController else {
            return
        }
        collectionView.delegate = customPickerVC
        collectionView.dataSource = customPickerVC
    }
    
    // MARK: UINavigationBar leftBarButton / rightBarButton 이벤트
    @objc func handleBackButtonTapped(){
        guard let parentVC = self.parentViewController as? CustomPickerViewController else { return }
        
        parentVC.dismiss(animated: true)
    }
    
    @objc func handleCompletionButtonTapped(){
        guard let parentVC = self.parentViewController as? CustomPickerViewController else { return }
        
        parentVC.dismiss(animated: true)
    }
}
