//
//  SignUpViewController.swift
//  instagram
//
//  Created by 박경준 on 2023/05/03.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let signupView = SignUpView()
        self.view = signupView
        
        signupView.delegate = self
        setupGesture(target: signupView.profileImageContainerView, action: #selector(handleTouchUpImageView))
    }
    
    @objc func handleTouchUpImageView(){
        print("hello")
    }
    
}

extension SignUpViewController: GestureDelegate{
    func setupGesture(target: UIView, action: Selector?) {
        print(target)
        let gesture = UITapGestureRecognizer(target: self, action: action)
        target.addGestureRecognizer(gesture)
        target.isUserInteractionEnabled = true
    }
}
