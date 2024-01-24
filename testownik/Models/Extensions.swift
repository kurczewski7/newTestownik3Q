//
//  Extensions.swift
//  SwiftyDocPicker
//

import Foundation
import UIKit

extension UIButton {
    var fillLevel: Float {
        get {
            return  self.frame.width > 0 ? Float(self.intrinsicContentSize.width / self.frame.width) : 1.0
        }
    }
}
extension UILabel {
    func scrollLeft() {
        self.textAlignment = .left
        UIView.animate(withDuration: 4.5, delay: 0.5, options: .curveEaseInOut) {
            self.textAlignment = .right
            self.layoutIfNeeded()
        } completion: { finish in
            self.textAlignment = .center
        }
    }
        // let labelX = UILabel()
        //labelX.alignmentRectInsets.left
        //labelX.textAlignment = .left
        
        //                UIView.animate(withDuration: 0.5, animations: {
        //                    self.fadedView.alpha = 0.0
        //                }) { (finished) in
        //                    self.fadedView.isHidden = true
        //                    self.recordingView.isHidden = true
        //                    self.tableView.reloadData()
        //                }

        


}
extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
extension UIView {
    func setGradientBackgroundColor(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat,
                paddingRight: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top       {      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true             }
        if let left = left     {      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true          }
        if let bottom = bottom {      self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true    }
        if let right = right   {      self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true      }
        if width != 0          {      self.widthAnchor.constraint(equalToConstant: width).isActive = true                       }
        if height != 0         {      self.heightAnchor.constraint(equalToConstant: height).isActive = true                     }
    }
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
}
extension Int16 {
    func toInt() -> Int {
        return Int(self)
    }
}
    extension Int {
        func toInt16() -> Int16 {
            return Int16(self)
        }
}
extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
    func keysForValue(value: Value) -> [Key] {
        return compactMap { (key: Key, val: Value) -> Key? in
        value == val ? key : nil
      }
    }
}
