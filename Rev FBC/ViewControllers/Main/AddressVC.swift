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
import MessageUI

class AddressVC: SlideableMenuVC {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.applyShadow()
            mapView.layer.cornerRadius = 4
            
        }
    }
    
    @IBOutlet weak var addressContainer: UIView! {
        didSet {
            addressContainer.backgroundColor = UIColor.appGray()
            addressContainer.layer.cornerRadius = 2
            addressContainer.applyShadow()
        }
    }
    
    @IBOutlet weak var infoContainer: UIView! {
        didSet {
            infoContainer.backgroundColor = UIColor.appGray()
            infoContainer.layer.cornerRadius = 2
            infoContainer.applyShadow()
        }
    }
    
    @IBOutlet weak var contactContainer: UIView! {
        didSet {
            contactContainer.backgroundColor = UIColor.appGray()
            contactContainer.layer.cornerRadius = 2
            contactContainer.applyShadow()
        }
    }
    
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.text = "Where?\n27464 Jefferson Ave, Temecula, CA 92590"
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = "When?\nEvery wednesday night, 7pm to 8:30pm"
        }
    }
    
    @IBOutlet weak var contactLabel: UILabel! {
        didSet {
            contactLabel.text = "Who?\nContact our pastor Morgan Maitland."
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        findLocation()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapAddressContainer))
        addressContainer.addGestureRecognizer(tap)
    }
    

    @IBAction func getDirections(_ sender: AppButton) {
        getCoordinateFromAddress(address: "27464 Jefferson Ave, Temecula, CA 92590").then({ coordinate in
            guard let coord = coordinate else { return }
            
            let coordinate = CLLocationCoordinate2DMake(coord.latitude , coord.longitude)
            let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.02))
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
            mapItem.name = "The Revolution"
            mapItem.openInMaps(launchOptions: options)
        })
        
    }
    
    @IBAction func shareAddress(_ sender: AppButton) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Address for The Revolution:\n27464 Jefferson Ave, Temecula, CA 92590"
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Cannot send text", message: "It looks like your device cannot send messages at this time.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(dismissAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func findLocation(){
        let locationAnnotation = MKPointAnnotation()
        
        getCoordinateFromAddress(address: "27464 Jefferson Ave, Temecula, CA 92590").then({ coordinate in
            guard let coord = coordinate else { return }
            
            locationAnnotation.coordinate = coord
            locationAnnotation.title = "The Revolution"
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
    
    func didTapAddressContainer(){
        let copyAddressItem = UIMenuItem(title: "Copy address", action: #selector(self.copyAddress))
        UIMenuController.shared.menuItems?.removeAll()
        UIMenuController.shared.menuItems = [copyAddressItem]
        UIMenuController.shared.update()
        
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        menu.setTargetRect(self.addressContainer.frame, in: self.addressContainer.superview!)
        menu.setMenuVisible(true, animated: true)
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return  action == #selector(self.copyAddress)
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func copyAddress(){
        UIPasteboard.general.string = "27464 Jefferson Ave, Temecula, CA 92590"
    }
}

extension AddressVC : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }

}
