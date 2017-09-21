//
//  EventDetailMapCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 9/18/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import MapKit

class EventDetailMapCell: UITableViewCell, MapViewManager, LocationManager {
    
    
    @IBOutlet weak var map: MKMapView!

    
    var event : Event? {
        didSet {
            guard let e = event else { return }
            findLocation(event: e, onMap: map)
        }
    }
    
}
