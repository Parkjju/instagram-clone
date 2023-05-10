//
//  CustomPHPickerViewController.swift
//  instagram
//
//  Created by Jun on 2023/05/10.
//

import UIKit
import PhotosUI
class CustomPHPickerViewController: UIViewController {
    
    var delegate: PHPickerViewControllerDelegate?{
        didSet{
            picker.delegate = delegate
        }
    }
    
    let picker: PHPickerViewController = {
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let pickerVC = PHPickerViewController(configuration: configuration)
        
        return pickerVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello~")
        
        self.addChild(picker)
        view.addSubview(picker.view)
        picker.didMove(toParent: self)
        
        // picker 델리게이트를 customPHPicker에 위임
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = .lightGray
    }
}

// 1. PHPickerViewController의 뷰를 커스텀하려고 함
// 2. 커스텀 뷰컨 클래스를 하나 정의하여 child로 삽입하는 방식
// 3. 삽입된 PHPickerViewController가 동작하려면 delegate 지정이 되어야함
// 4. parent에 접근 및 타입캐스팅 -> delegate 직접 지정
// 5. PHPickerViewController의 뷰를 커스텀하는 것은 불가능
