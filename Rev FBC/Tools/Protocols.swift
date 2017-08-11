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

// MARK: - Coordinates

protocol CoordinateManager {
    func getCoordinateFromAddress(address: String) -> Promise<CLLocationCoordinate2D?>
}

extension CoordinateManager {
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
