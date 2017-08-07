//
//  AppButton.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class AppButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.backgroundColor = UIColor(white: 0, alpha: 0).cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 2
        layer.masksToBounds = true
        layer.borderColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1).cgColor
        setTitleColor(UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1), for: .normal)
    }

}
