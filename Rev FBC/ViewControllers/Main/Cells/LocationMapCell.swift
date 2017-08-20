//
//  LocationMapCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/11/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationMapCell: UITableViewCell, MapViewManager, LocationManager {

    @IBOutlet weak var mapView: MKMapView!
    
    var event : Event? {
        didSet {
            guard let event = event else { return }
            findLocation(event: event, onMap: mapView)
        }
    }
    
}
