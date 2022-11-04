//
//  Color.swift
//  FlyUtils
//
//  Created by FlyKite on 2022/11/4.
//

import UIKit

public extension UIColor {
    convenience init(hex hexValue: Int, alpha: CGFloat) {
        let red = CGFloat(hexValue >> 16) / 255.0
        let green = CGFloat((hexValue >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexValue & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(p3Hex hexValue: Int, alpha: CGFloat) {
        let red = CGFloat(hexValue >> 16) / 255.0
        let green = CGFloat((hexValue >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexValue & 0xFF) / 255.0
        self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    }
}

public extension Int {
    var rgbColor: UIColor {
        return rgbColor(alpha: 1)
    }
    
    func rgbColor(alpha: CGFloat) -> UIColor {
        return UIColor(hex: self, alpha: alpha)
    }
    
    var p3Color: UIColor {
        return p3Color(alpha: 1)
    }
    
    func p3Color(alpha: CGFloat) -> UIColor {
        return UIColor(p3Hex: self, alpha: alpha)
    }
}
