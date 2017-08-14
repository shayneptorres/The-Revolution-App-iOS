//
//  LocationCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/10/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationCellDelegate {
    func handleTap(section: Int)
}

class LocationCell: UITableViewHeaderFooterView, CoordinateManager {
    
    @IBOutlet weak var container: UIView! {
        didSet {
            container.applyShadow()
        }
    }
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var locationDate: UILabel!
    
    var delegate : LocationCellDelegate?
    
    var section : Int?
    
    var event : Event? {
        didSet {
            guard let event = event else { return }
            updateUI(event)
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
            self.container.addGestureRecognizer(tap)
        }
    }
    
    func didTap(){
        guard let index = section else { return }
        delegate?.handleTap(section: index)
    }
    
    func updateUI(_ event: Event){
        
        locationName.text = event.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE's' 'at' h:mm a"
        
        locationDate.text = formatter.string(from: event.startDate)
        
        if event.name == "The Revolution" {
            eventImage.image = UIImage(named: "logo1")
        } else {
            eventImage.image = UIImage(named: "fbcIcon")
        }
    }
    
}
