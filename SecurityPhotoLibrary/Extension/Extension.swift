//
//  Extension.swift
//  SecurityPhotoLibrary
//
//  Created by Dmitry Semenuk on 12/04/2020.
//  Copyright © 2020 Dmitry Semenuk. All rights reserved.
//

import Foundation
import UIKit

enum Border: Int {
    case top = 0
    case bottom
    case right
    case left
}

extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 6.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }

    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}

extension UIView{
    
    func rotate(degrees: CGFloat) {

        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))

        // If you like to use layer you can uncomment the following line
        //layer.transform = CATransform3DMakeRotation(degreesToRadians(degrees), 0.0, 0.0, 1.0)
    }
    
    func addBorder(for side: Border, withColor color: UIColor, borderWidth: CGFloat){
       let borderLayer = CALayer()
       borderLayer.backgroundColor = color.cgColor

       let xOrigin: CGFloat = (side == .right ? frame.width - borderWidth : 0)
       let yOrigin: CGFloat = (side == .bottom ? frame.height - borderWidth : 0)

       let width: CGFloat = (side == .right || side == .left) ? borderWidth : frame.width
       let height: CGFloat = (side == .top || side == .bottom) ? borderWidth : frame.height

       borderLayer.frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
       layer.addSublayer(borderLayer)
    }
    
    func dropShadow(
        color: UIColor = .black,
        opacity: Float = 0.8,
        offSet: CGSize = CGSize(width: 0, height: 0),
        radius: CGFloat = 8,
        scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func shake(for duration: TimeInterval = 0.5, withTranslation translation: CGFloat = 20) {
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.5) {
            self.transform = CGAffineTransform(translationX: translation, y: 0)
        }

        propertyAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: 0.2)

        propertyAnimator.startAnimation()
    }
    
    
}

extension UIColor {
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UILabel{
    func addCustomFont(_ nameFont: String, sizeFont: CGFloat, color: String){
        self.font = UIFont(name: nameFont, size: sizeFont)
        self.textColor = UIColor.init(color)
    }
}

extension UIButton{
    func addCustomFont(_ nameFont: String, sizeFont: CGFloat, color: String, state: UIControl.State? = .normal){
        guard let nState = state else {return}
        
        self.setTitleColor(UIColor.init(color), for: nState)
        self.titleLabel?.font = UIFont(name: nameFont, size: sizeFont)
        
    }
}

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.blue.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 25, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 50, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

extension CALayer {
    func updateBorderLayer(for side: Border, withViewFrame viewFrame: CGRect) {
        let xOrigin: CGFloat = (side == .right ? viewFrame.width - frame.width : 0)
        let yOrigin: CGFloat = (side == .bottom ? viewFrame.height - frame.height : 0)

        let width: CGFloat = (side == .right || side == .left) ? frame.width : viewFrame.width
        let height: CGFloat = (side == .top || side == .bottom) ? frame.height : viewFrame.height

        frame = CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
    }
}


extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
