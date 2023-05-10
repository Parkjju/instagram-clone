//
//  SignUpViewController.swift
//  instagram
//
//  Created by 박경준 on 2023/05/03.
//

import UIKit
import PhotosUI

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signupView = SignUpView()
        self.view = signupView
        signupView.delegate = self
        signupView.pickerDelegate = self
        
    }
}

// UITapGestureRecognizer action 파라미터에 전달되는 Selector는 반드시 target 객체 내에 정의되어 있어야 함!
// target 객체를 단순히 self로 지정하게 될 경우 -> action에 전달된 Selector를 SignUpViewController 인스턴스 내에서 찾게 되는데 해당 인스턴스에는 setupGesture 함수에 전달된 action 셀렉터가 정의되어 있지 않음
// signupView 객체 내에는 @objc handleTapGesture 함수가 정의되어 있고, 셀렉터로 해당 함수를 지정해서 가져올 수 있음!
extension SignUpViewController: GestureDelegate{
    func setupGesture(gestureTarget: UIView, action: Selector) {
        
        guard let signupView = self.view as? SignUpView else {return}
        let gesture = UITapGestureRecognizer(target: signupView, action: action)
        signupView.profileImageContainerView.addGestureRecognizer(gesture)
        signupView.profileImageContainerView.isUserInteractionEnabled = true
    }
}

extension SignUpViewController: PickerDelegate{
    func setupPickerView(picker: CustomPickerViewController) {
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
}


