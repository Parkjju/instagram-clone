//
//  LoginViewController.swift
//  instagram
//
//  Created by 박경준 on 2023/05/03.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginView = LoginView()
        self.view = loginView
        
        loginView.delegate = self
    }
}

extension LoginViewController: ViewButtonDelegate{
    func didTapButton() {
        let signupVC = SignUpViewController()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
}
