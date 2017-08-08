//
//  UIView.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/7/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
     Applies a small shadow to the bottom side of a UIview
     
     - Author:
     Shayne Torres
     
     - Returns:
     void
     
     - Parameters:
     none
     */
    func applyShadow(){
        self.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }
}
