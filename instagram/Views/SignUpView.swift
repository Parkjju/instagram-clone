//
//  SignUpView.swift
//  instagram
//
//  Created by 박경준 on 2023/05/04.
//

import UIKit
import Firebase

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
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름"
        tf.backgroundColor = UIColor(white:0, alpha:0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        
        return tf
    }()
    
    let fullnameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "유저명"
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
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let signupButton: UIButton = {
        let btn = UIButton(type:.system)
        btn.backgroundColor = .systemBlue
        
        let attrString = NSMutableAttributedString(string:"가입하기", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        btn.setAttributedTitle(attrString, for: .normal)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        btn.layer.opacity = 0.5
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return btn
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
        self.backgroundColor = .white
        layoutViews()
    }
    
    func layoutViews(){
        self.addSubview(profileImageContainerView)
        self.addSubview(emailTextField)
        self.addSubview(fullnameTextField)
        self.addSubview(usernameTextField)
        self.addSubview(passwordTextField)
        self.addSubview(signupButton)
        
        profileImageContainerView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 160, paddingLeft: 20, paddingRight: 20, paddingBottom: 0, width: 0, height: 0)
        emailTextField.anchor(top: profileImageContainerView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 60, paddingLeft: 30, paddingRight: 30, paddingBottom: 0, width: 0, height: 40)
        fullnameTextField.anchor(top: emailTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 30, paddingRight: 30, paddingBottom: 0, width: 0, height: 40)
        usernameTextField.anchor(top: fullnameTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 30, paddingRight: 30, paddingBottom: 0, width: 0, height: 40)
        passwordTextField.anchor(top: usernameTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 30, paddingRight: 30, paddingBottom: 0, width: 0, height: 40)
        signupButton.anchor(top: passwordTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 30, paddingRight: 30, paddingBottom: 0, width: 0, height: 40)
    }
    
    @objc func handleSignUp(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password){(user, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            print("created user: \(user)")
        }
        print(email)
    }
    
    @objc func formValidation(){
        guard emailTextField.hasText, passwordTextField.hasText else {
            signupButton.isEnabled = false
            signupButton.layer.opacity = 0.5
            return
        }
        
        signupButton.isEnabled = true
        signupButton.layer.opacity = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    

}