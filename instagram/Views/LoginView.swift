//
//  LoginView.swift
//  instagram
//
//  Created by 박경준 on 2023/05/03.
//

import UIKit

class LoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupUI()
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "전화번호, 사용자 이름 또는 이메일"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "패스워드"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.layer.cornerRadius = 5
        btn.setTitle("로그인", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    let logoContainerView: UIView = {
        let lv = UIView()
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        logoImageView.contentMode = .scaleAspectFill
        lv.addSubview(logoImageView)
        
        logoImageView.anchor(top: nil, left: nil, right: nil, bottom: nil, paddingTop: 0,  paddingLeft: 0, paddingRight: 0,paddingBottom: 0, width: 150, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: lv.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: lv.centerYAnchor).isActive = true
        return lv
    }()
    
    let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "계정이 없으신가요? ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "가입하기", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        return btn
    }()
    
    func setupUI(){
        self.backgroundColor = .white
        
        let stackview = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        self.addSubview(stackview)
        self.addSubview(logoContainerView)
        self.addSubview(dontHaveAccountButton)
        
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.distribution = .fillEqually
        stackview.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 200, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 140)
        
        
        logoContainerView.anchor(top: nil, left: self.leftAnchor, right: self.rightAnchor, bottom: stackview.topAnchor, paddingTop: 0,  paddingLeft: 20, paddingRight: 20,  paddingBottom: 30, width: 0, height: 50)
        
        dontHaveAccountButton.anchor(top: nil, left: self.leftAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, paddingTop: 0, paddingLeft: 20, paddingRight: 20, paddingBottom: 40, width: 0, height: 40)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
}
