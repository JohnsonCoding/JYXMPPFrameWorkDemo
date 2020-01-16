//
//  UIColor+JY.swift
//  EdlOA
//
//  Created by 江勇 on 2019/1/3.
//  Copyright © 2019 edaili. All rights reserved.
//
import UIKit

extension UIColor {
    
    static func Hex(with hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var rgb: CUnsignedInt = 0
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        scanner.scanHexInt32(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat((rgb & 0xFF)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
}


