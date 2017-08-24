//
//  UpcomingEventDetailVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/14/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class UpcomingEventDetailVC: UIViewController, MapViewManager, LocationManager {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var container: UIView! {
        didSet {
            container.applyShadow()
            container.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var event : Event?
    
    func updateUI(event: Event){
        navigationController?.navigationBar.tintColor = UIColor(netHex: 0xF0C930)
        
        eventNameLabel.text = event.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd 'at' h:mm a"
        
        timeLabel.text = formatter.string(from: event.startDate)
        addressLabel.text = event.address
        infoLabel.text = event.desc
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let event = event else { return }
        updateUI(event: event)
        findLocation(event: event, onMap: mapView)
    }

    @IBAction func getDirections(_ sender: UIButton) {
        guard let event = event else { return }
        directions(event: event)
    }
    
    @IBAction func deleteEvent(_ sender: UIButton) {
        guard let event = event else { return }
        FirebaseService.instance.deleteEvent(event: event)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editEvent(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEvent" {
            let addEventVC = segue.destination as! AddEventVC
            addEventVC.event = self.event
        }
    }


}
