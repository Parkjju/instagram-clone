//
//  Extensions.swift
//  instagram
//
//  Created by 박경준 on 2023/05/03.
//

import UIKit
import Photos

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
    func newScaleOfImage(targetSize: CGSize, autoResize: Bool) -> CGSize{
        // 가로세로 스케일링 비율 측정
        let widthScaleRatio = targetSize.width / self.size.width
        let heightScaleRatio = targetSize.height / self.size.height
        
        // 가로세로 스케일링 비율 중 더 큰쪽에 맞추기
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        
        // 이미지 리사이징시 비율은 맞추되, 오토레이아웃에 설정해둔 height값 기준으로 크기를 최대높이를 조절한다
        return CGSize(width: self.size.width * scaleFactor, height: autoResize ? self.size.height * scaleFactor : 100)
    }
    
    // autoResize 파라미터가 필요할지 -> 나중에 프로필사진 등록 후에 확인필요
    func scalePreservingAspectRatio(targetSize: CGSize, autoResize: Bool) -> UIImage{
        
        // 새로운 스케일 계산
        let scaledSize = newScaleOfImage(targetSize: targetSize, autoResize: autoResize)
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

// MARK: UIView에서 parent ViewController를 찾아주는 확장 함수
extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}

// MARK: 로컬 이미지 fetch 함수
func fetchPhotos() -> PHFetchResult<PHAsset>{
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    return PHAsset.fetchAssets(with: .image, options: fetchOptions)
}

// MARK: 네비게이션 바 디폴트컬러 속성 추가
extension UIColor{
    static let defaultNavigationColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
}

// MARK: ImageView extension - 핀치 후 이미지 확대
var initialPoint: CGPoint?

extension UIImageView{
    
    @objc func startZooming(_ sender: UIPinchGestureRecognizer){
        
        if(sender.view!.transform.a > 0.6){
            let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
            
            guard let scale = scaleResult else { return }
            sender.view?.transform = scale
            sender.scale = 1
        }
        
        if(sender.state == .ended){
            checkImageOriginIsZero(sender)
        }
        
    }
    
    @objc func startDragging(_ sender: UIPanGestureRecognizer){
        // 이동량을 더하는 형태 -> 계속 누적되어 목표값을 넘어서게됨
        // 직전의 translate값을 저장
        // 변화하는 상태값을 계속 트래킹하며 이미지뷰 origin위치를 변경해줘야함
        
        if(sender.view!.transform.a > 1 ){
            sender.view!.frame.origin.x += sender.translation(in: sender.view).x
            sender.view!.frame.origin.y += sender.translation(in: sender.view).y
            
            sender.setTranslation(.zero, in: sender.view)
            
        }else{
            sender.view?.frame.origin = sender.translation(in: sender.view)
        }

        
        
        if(sender.state == .ended){
            checkImageOriginIsZero(sender)
        }
    }
    
    func checkImageOriginIsZero(_ sender: UIPanGestureRecognizer){
        if(sender.view!.transform.a != 1){
            
            if(sender.view!.frame.origin.x > 0){
                UIView.animate(withDuration: 0.3) {
                    sender.view?.frame.origin.x = 0
                }
            }else if(sender.view!.frame.origin.y > 0 ){
                UIView.animate(withDuration: 0.3) {
                    sender.view?.frame.origin.y = 0
                }
            }
        }else{
            if(sender.view!.frame.origin.x > 0 || sender.view!.frame.origin.x < 0 || sender.view!.frame.origin.y > 0){
                UIView.animate(withDuration: 0.3) {
                    sender.view?.frame.origin.x = 0
                    sender.view?.frame.origin.y = 0
                }
            }
        }
        // 스케일링 되어있는 경우와 그렇지 않은 경우를 구분해서 구현해야함

    }
    
    func checkImageOriginIsZero(_ sender: UIPinchGestureRecognizer){
        if(sender.view!.frame.origin.x > 0 || sender.view!.frame.origin.y > 0){
            let imageView = sender.view as! UIImageView
            UIView.animate(withDuration: 0.3) {
                sender.view!.transform.a = 1
                sender.view!.transform.d = 1
                
                imageView.image = imageView.image?.scalePreservingAspectRatio(targetSize: CGSize(width: sender.view!.superview!.frame.width, height: sender.view!.superview!.frame.width), autoResize: true)
            }
            
            
        }
    }
    
    func enableZoom(){
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pinchGesture)
    }
    
    func enableDrag(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(startDragging))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
    }
}

// MARK: 이미지 자르기 함수
// 뷰의 가로 - 세로를 기준으로 이미지를 자르
func cropImage(sourceImage: UIImage, view: UIView, imageView: UIImageView) -> UIImage{

    // Determines the x,y coordinate of a centered
    // sideLength by sideLength square
    let sourceSize = view.frame.size

    // The cropRect is the rect of the image to keep,
    // in this case centered
    let cropRect = CGRect(
        x: 0,
        y: 0,
        width:  sourceSize.width,
        height:sourceSize.height
    ).integral

    // Center crop the image
    let sourceCGImage = sourceImage.cgImage!
    let croppedCGImage = sourceCGImage.cropping(
        to: cropRect
    )!
    
    return UIImage(cgImage: croppedCGImage)
}
