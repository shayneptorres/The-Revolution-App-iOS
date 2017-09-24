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
    
    var cellWidth = 0
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var overlayView: UIView!
    
    var event : Event? {
        didSet {
            guard let e = event else { return }
            findLocation(event: e, onMap: map)
        }
    }
    
}
