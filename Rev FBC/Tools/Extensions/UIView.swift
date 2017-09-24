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
    
    func roundCorners(corners: UIRectCorner, radii: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radii, height: radii))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func roundCornersForTableViewCell(corners: UIRectCorner, radii: CGFloat, tableViewWidth: CGFloat, contentSpacing: CGFloat) {
        let viewBounds = self.bounds
        let rect = CGRect(x: viewBounds.minX,
                          y: viewBounds.minY,
                          width: tableViewWidth - contentSpacing, // THis magic number is the size of the space between the card in the table view to the tableviews edges
            height: viewBounds.height)
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radii, height: radii))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
