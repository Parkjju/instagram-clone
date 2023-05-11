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
    
    // MARK: 완료버튼 클릭시 CustomView에 있는 이미지를 SignUpVC의 이미지에 넣어줘야함.
    @objc func handleCompletionButtonTapped(){
        // 1. parentViewController 속성을 통해 customVC에 접근
        guard let customPickerVC = self.parentViewController as? CustomPickerViewController else { return }
        
        // 2. 로그인 뷰컨과 회원가입 뷰컨을 임베딩한 네비게이션 컨트롤러 - presetingVC 속성 접근으로 인해 네비게이션을 참조하게됨
        let embededInLoginAndSignupVC = self.parentViewController?.presentingViewController as! UINavigationController
        
        // 3. 네비게이션 컨트롤러 맨 마지막 컨트롤러는 signupVC
        let signupVC = embededInLoginAndSignupVC.viewControllers.last as! SignUpViewController
        
        // 4. signupVC의 뷰에 접근하여 이미지뷰 디폴트 값인 avatar.png를 customVC의 이미지로 교체해주는 작업
        let signupView = signupVC.view as! SignUpView
        let imageView = self.previewImageContainerView.subviews.first as! UIImageView
        let signupViewProfileImageView = signupView.profileImageContainerView.subviews.first as! UIImageView
        
        // 5. 코너 부여 및 이미지 리사이징 - 해상도 깨짐 방지
        
        signupViewProfileImageView.layer.cornerRadius = 50
        signupViewProfileImageView.image = cropImage(sourceImage: imageView.image!, view: previewImageContainerView, imageView: signupViewProfileImageView).scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100), autoResize: false)
        print(cropImage(sourceImage: imageView.image!, view: previewImageContainerView, imageView: signupViewProfileImageView).scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100), autoResize: false))
        
        
        
        customPickerVC.dismiss(animated: true)
    }
}
