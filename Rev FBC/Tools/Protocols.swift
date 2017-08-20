//
//  Protocols.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

// MARK: - Locations

protocol LocationManager {
    
}

extension LocationManager  {
    
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
    
    func directions(event: Event) {
        getCoordinateFromAddress(address: event.address).then({ coordinate in
            guard let coord = coordinate else { return }
            
            let coordinate = CLLocationCoordinate2DMake(coord.latitude , coord.longitude)
            let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.02))
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
            mapItem.name = event.name
            mapItem.openInMaps(launchOptions: options)
        })
    }
}

protocol MapViewManager {
}

extension MapViewManager where Self : LocationManager{
    func findLocation(event: Event, onMap mapView: MKMapView){
        
        let locationAnnotation = MKPointAnnotation()
        
        getCoordinateFromAddress(address: event.address).then({ coordinate in
            guard let coord = coordinate else { return }
            
            locationAnnotation.coordinate = coord
            locationAnnotation.title = event.name
            mapView.addAnnotation(locationAnnotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        })
    }
}
