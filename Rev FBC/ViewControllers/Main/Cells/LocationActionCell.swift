//
//  LocationActionCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/10/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

protocol LocationAddressCellDelegate {
    func contact(event: Event)
    func directions(event: Event)
    func sendAddress(event: Event)
    func website(event: Event)
}

class LocationActionCell: UITableViewCell {
    
    @IBOutlet weak var container: UIView! {
        didSet {
            container.applyShadow()
        }
    }
    
    
    var delegate : LocationAddressCellDelegate?
    var event : Event?
    
    @IBAction func contact(_ sender: UIButton) {
        guard let event = event else { return }
        delegate?.contact(event: event)
    }
    
    @IBAction func getDirections(_ sender: UIButton) {
        guard let event = event else { return }
        delegate?.directions(event: event)
    }
    
    @IBAction func sendAddress(_ sender: UIButton) {
        guard let event = event else { return }
        delegate?.sendAddress(event: event)
    }
    
    @IBAction func website(_ sender: UIButton) {
        guard let event = event else { return }
        delegate?.website(event: event)
    }
    
    
}
