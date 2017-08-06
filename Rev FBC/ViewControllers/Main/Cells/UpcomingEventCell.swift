//
//  UpcomingEventCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class UpcomingEventCell: UITableViewCell {
    
    @IBOutlet weak var dateContainer: UIView! {
        didSet {
            dateContainer.layer.cornerRadius = dateContainer.bounds.height/2
            dateContainer.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        }
    }
    
    
    var event: Event? {
        didSet {
            guard let event = event else { return }
            updateUI(event)
        }
    }
    
    func updateUI(_ event: Event){
        
    }
}
