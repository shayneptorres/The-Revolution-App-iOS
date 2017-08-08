//
//  Colors.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/7/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /**
     Allow the initialization of UIcolors with RGB values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    /**
     Allow the initialization of UIcolors with HEX Values
     */
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    static func appGray() -> UIColor {
        return UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
    }
    
}
