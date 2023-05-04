//
//  SignUpView.swift
//  instagram
//
//  Created by 박경준 on 2023/05/04.
//

import UIKit

class SignUpView: UIView {
    let profileImageContainerView: UIView = {
        let view = UIView()
        let avatarImageView = UIImageView(image: UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate))
        avatarImageView.tintColor = .lightGray
        
        view.addSubview(avatarImageView)

        avatarImageView.contentMode = .scaleAspectFill
        
        avatarImageView.anchor(top: nil, left: nil, right: nil, bottom: nil, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 40, height: 40)
        avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "전화번호, 사용자 이름 또는 이메일"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupUI()
    }
    
    func setupUI(){
        self.addSubview(profileImageContainerView)
        self.backgroundColor = .white
        
        profileImageContainerView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 160, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 0)
    }

}
