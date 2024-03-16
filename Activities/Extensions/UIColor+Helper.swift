//
//  UIColor+Helper.swift
//  QuickLayouts
//
//  Created by Chikinov Maxim on 14.09.2023.
//

import UIKit

//  MARK: - Methods
extension UIColor {
    class var random: UIColor {
        let red = CGFloat(arc4random() % 255) / CGFloat(255)
        let green = CGFloat(arc4random() % 255) / CGFloat(255)
        let blue = CGFloat(arc4random() % 255) / CGFloat(255)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        ).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    func interpolateRGBColorTo(end: UIColor, fraction: CGFloat) -> UIColor {
        var f = max(0, fraction)
        f = min(1, fraction)
        
        let c1 = self.cgColor.components!
        let c2 = end.cgColor.components!
        
        let redSum: CGFloat = c2[0] - c1[0]
        let redValue = c1[0] + redSum * f
        let r: CGFloat = CGFloat(redValue)
        
        let greenSum: CGFloat = c2[1] - c1[1]
        let greenValue = c1[1] + greenSum * f
        let g: CGFloat = CGFloat(greenValue)
        
        let blueSum: CGFloat = c2[2] - c1[2]
        let blueValue = c1[2] + blueSum * f
        let b: CGFloat = CGFloat(blueValue)
        
        let alphaSum: CGFloat = c2[3] - c1[3]
        let alphaValue = c1[3] + alphaSum * f
        let a: CGFloat = CGFloat(alphaValue)
        
        return UIColor.init(red:r, green:g, blue:b, alpha:a)
    }
    
    func lighter(multiplier: CGFloat = 1.3) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(hue: h, saturation: s, brightness: min(b * multiplier, 1.0), alpha: a)
        } else {
            return self
        }
    }
    
    func darker(multiplier: CGFloat = 0.75) -> UIColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return UIColor(hue: h, saturation: s, brightness: b * multiplier, alpha: a)
        } else {
            return self
        }
    }
}
