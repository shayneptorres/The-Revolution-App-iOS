//
//  FormTextField.swift
//  Ministry Hub
//
//  Created by Shayne Torres on 7/29/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import  JVFloatLabeledTextField

//@IBDesignable
class FormTextField: JVFloatLabeledTextField {
    
    @IBInspectable
    var borderWidth : CGFloat = 1
    
    @IBInspectable
    var borderColor : UIColor = .white
    
    @IBInspectable
    var drawBottomBorder : Bool = true
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBorder()
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func drawBorder(){
        if drawBottomBorder {
            let btmBorder = UIView(frame: CGRect(x: 0, y: self.bounds.maxY - borderWidth, width: self.frame.width, height: borderWidth))
            btmBorder.backgroundColor = borderColor
            self.addSubview(btmBorder)
        }
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}
