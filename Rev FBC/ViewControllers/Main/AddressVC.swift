//
//  AddressVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressVC: SlideableMenuVC {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        findLocation()
    }
    
    func findLocation(){
        let locationAnnotation = MKPointAnnotation()
        
        getCoordinateFromAddress(address: "27464 Jefferson Ave, Temecula, CA 92590").then({ coordinate in
            guard let coord = coordinate else { return }
            
            locationAnnotation.coordinate = coord
            locationAnnotation.title = "Rev FBC Midweek Facility"
            self.mapView.addAnnotation(locationAnnotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        })
        
    }

    func getCoordinateFromAddress(address: String) -> Promise<CLLocationCoordinate2D?> {
        let geoCoder = CLGeocoder()
        let promise = Promise<CLLocationCoordinate2D?>(work: { fulfill, reject in
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        fulfill(nil)
                        return
                }
                fulfill(location.coordinate)
            }
        })
        return promise
    }
}
