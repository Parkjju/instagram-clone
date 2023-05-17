//
//  CustomPickerView.swift
//  instagram
//
//  Created by Jun on 2023/05/10.
//

import UIKit
import Photos
import SnapKit

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
    
    let collectionViewSortingBar: UIView = {
        let view = UIView()
        let btn = UIButton(type: .system)
        
        view.addSubview(btn)
        
        btn.setTitle("최근 항목  ", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.down")?.scalePreservingAspectRatio(targetSize: CGSize(width: 10, height: 20)).withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.setTitleColor(.black, for: .normal)
        
        
        btn.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(10)
            $0.centerY.equalTo(view.snp.centerY)
        }
        
        
        return view
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
        preImageView.contentMode = .scaleAspectFill
        view.addSubview(preImageView)
        
        // 상-하 사이즈를 늘리다가 확대되면서 이미지가 벗어나고 있음
        // 오토레이아웃 설정에서는 위에만 붙여두고 이미지 fetch시에 높이값을 크게 부여하면?
        // 이미지에 대한 aspectRatio 속성을 부여해보자
        preImageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.bottom.equalTo(view.snp.bottom)
        }
        // 터치이벤트 발생후 previewImage뷰에 이미지 등록할때 aspect제약조건ㅇ추가해보기ㅜ 

        
        view.clipsToBounds = true
        
        return view
    }()
    
    var isConstraintChangeStarted: Bool = false
    var scrollContentOffsetY:CGFloat = 0
    
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
        addPanGestureToView()
    }
    
    func layoutViews(){
        [navBar, previewImageContainerView, collectionView, collectionViewSortingBar].forEach { self.addSubview($0) }
        
        navBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
        }
        
        previewImageContainerView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.equalTo(self.snp.leading)
            $0.trailing.equalTo(self.snp.trailing)
            $0.height.equalTo(self.frame.width)
        }
        
        collectionViewSortingBar.snp.makeConstraints {
            $0.top.equalTo(previewImageContainerView.snp.bottom)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(collectionViewSortingBar.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    func setupCollectionView(){
        // 컬렉션뷰 델리게이트 연결
        guard let customPickerVC = self.parentViewController as? CustomPickerViewController else {
            return
        }
        collectionView.delegate = customPickerVC
        collectionView.dataSource = customPickerVC
        
        // 컬렉션뷰 레이아웃 설정
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let collectionCellWidth = LayoutValues.collectionCellWidth
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumInteritemSpacing = LayoutValues.spacingWidth
        flowLayout.minimumLineSpacing = LayoutValues.spacingHeight
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    func addPanGestureToView(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPanGestureHandler))
        panGesture.delegate = self.parentViewController as! CustomPickerViewController
        self.addGestureRecognizer(panGesture)
        self.isUserInteractionEnabled = true
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
        signupViewProfileImageView.image = cropImage(sourceImage: imageView.image!, view: previewImageContainerView, imageView: signupViewProfileImageView).scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100))
        print(cropImage(sourceImage: imageView.image!, view: previewImageContainerView, imageView: signupViewProfileImageView).scalePreservingAspectRatio(targetSize: CGSize(width: 100, height: 100)))
        
        customPickerVC.dismiss(animated: true)
    }
    
    // previewContainer에서 시작된 제스처면
    @objc func viewPanGestureHandler(_ sender: UIPanGestureRecognizer){
        if(sender.location(in: self).y < self.frame.height / 2 && sender.translation(in: self).y < 0 ){
            
            if(!isConstraintChangeStarted){
                sender.setTranslation(.zero, in: self)
                isConstraintChangeStarted = true
                scrollContentOffsetY = collectionView.contentOffset.y
            }
            
            navBar.snp.updateConstraints {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(sender.translation(in: self).y)
            }
            
            if(scrollContentOffsetY > 0){
                collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: scrollContentOffsetY), animated: false)
            }
            
            layoutIfNeeded()
        }else{
            UIView.animate(withDuration: 0.4) {
                self.navBar.snp.updateConstraints {
                    $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                }
                self.layoutIfNeeded()
            }
            isConstraintChangeStarted = false
        }
        
        if(sender.state == .ended && sender.location(in: self).y < (self.frame.height) * 3 / 4){
            UIView.animate(withDuration: 0.4) {
                self.navBar.snp.updateConstraints {
                    $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                }
                self.layoutIfNeeded()
            }
            isConstraintChangeStarted = false
        }
    }
}
