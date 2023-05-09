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
    }
}

extension SignUpViewController: GestureDelegate{
    func setupGesture(gestureTarget: UIView, action: Selector) {
        let gesture = UITapGestureRecognizer(target: self, action: action)
        
        guard let signupView = self.view as? SignUpView else {return}
        signupView.profileImageContainerView.addGestureRecognizer(gesture)
        signupView.profileImageContainerView.isUserInteractionEnabled = true
    }
}
