//
//  UpcomingEventCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class UpcomingEventCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var cardContainer: UIView! {
        didSet {
            cardContainer.applyShadow()
        }
    }
    
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
        
        let monthFormetter = DateFormatter()
        monthFormetter.dateFormat = "MMM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        name.text = event.name
        desc.text = "\(event.desc)"
        
        date.text = "\(monthFormetter.string(from: event.startDate))\n\(dayFormatter.string(from: event.startDate))"
        time.text = timeFormatter.string(from: event.startDate)
    }
}
