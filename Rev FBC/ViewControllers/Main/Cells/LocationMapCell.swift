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

class LocationMapCell: UITableViewCell, CoordinateManager {

    @IBOutlet weak var mapView: MKMapView!
    
    var event : Event? {
        didSet {
            guard let event = event else { return }
            findLocation(event: event)
        }
    }

    
    func findLocation(event: Event){
        
        let locationAnnotation = MKPointAnnotation()
        
        getCoordinateFromAddress(address: event.address).then({ coordinate in
            guard let coord = coordinate else { return }
            
            locationAnnotation.coordinate = coord
            locationAnnotation.title = event.name
            self.mapView.addAnnotation(locationAnnotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        })
    }
    
}
