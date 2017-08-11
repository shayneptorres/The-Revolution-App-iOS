//
//  LocationInfoCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/11/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class LocationInfoCell: UITableViewCell {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var container: UIView! {
        didSet {
            container.applyShadow()
        }
    }
    
}
