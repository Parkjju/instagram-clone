//
//  Extensions.swift
//  instagram
//
//  Created by 박경준 on 2023/05/03.
//

import UIKit

extension UIView{
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom:CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if width != 0{
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0{
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

// MARK: Image resizing
extension UIImage{
    func newScaleOfImage(targetSize: CGSize) -> CGSize{
        // 가로세로 스케일링 비율 측정
        let widthScaleRatio = targetSize.width / self.size.width
        let heightScaleRatio = targetSize.height / self.size.height
        
        // 가로세로 스케일링 비율 중 더 큰쪽에 맞추기
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        
        // 이미지 리사이징시 비율은 맞추되, 오토레이아웃에 설정해둔 height값 기준으로 크기를 최대높이를 조절한다
        return CGSize(width: self.size.width * scaleFactor, height: 100)
    }
    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage{
        
        // 새로운 스케일 계산
        let scaledSize = newScaleOfImage(targetSize: targetSize)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return scaledImage
    }
}

// MARK: 제스처 간단하게 추가하는 코드
final class BindableGestureRecognizer: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        action()
    }
}
