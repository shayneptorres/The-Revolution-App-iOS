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
import RxSwift
import Realm
import RealmSwift

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
    
    @IBOutlet weak var websiteBtn: UIButton! {
        didSet {
            handleWebsiteButton()
        }
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    var event = Variable<Event?>(nil)
    
    func handleWebsiteButton(){
        if let url = event.value?.url() {
            websiteBtn.isHidden = false
        }
    }
    
    func updateUI(event: Event){
        navigationController?.navigationBar.tintColor = UIColor(netHex: 0xF0C930)
        
        eventNameLabel.text = event.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd 'at' h:mm a"
        
        timeLabel.text = formatter.string(from: event.startDate)
        addressLabel.text = event.address
        infoLabel.text = event.desc
        
        handleWebsiteButton()
        
        if AdminService.instance.getUserCredentials() == nil {
            deleteBtn.isHidden = true
            navigationItem.rightBarButtonItem = nil
        } else {
            if navigationItem.rightBarButtonItem != nil { return }
            let btn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(segueToEdit))
            
            btn.tintColor = UIColor(netHex: 0xF0C930)
            editBtn = btn
            
            navigationItem.rightBarButtonItem = btn
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = .white
        
    }
    
    let db = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let event = event.value else { return }
        updateUI(event: event)
        findLocation(event: event, onMap: mapView)
        
        let realm = try! Realm()
        let events = realm.objects(Event.self)
        
//        Observable.collection(from: events)
//            .map({ evts in evts.toArray() })
//            .map({ evts in evts.filter({ $0.id == self.event.value?.id }).first })
//            .map({ e in e })
//            .bind(to: self.event)
//            .addDisposableTo(db)
        
        self.event.asObservable().subscribe({ [weak self] e in
            if let evt = e.element, let realEvt = evt {
                self?.updateUI(event: realEvt)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }).addDisposableTo(db)
        
    }

    @IBAction func getDirections(_ sender: UIButton) {
        guard let event = event.value else { return }
        directions(event: event)
    }
    
    @IBAction func goToWebsite(_ sender: UIButton) {
        if let url = event.value?.url() {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
    @IBAction func deleteEvent(_ sender: UIButton) {
        guard let event = event.value else { return }
        self.navigationController?.popViewController(animated: true)
        FirebaseService.instance.deleteEvent(event: event)
        
    }
    
    @IBAction func editEvent(_ sender: UIBarButtonItem) {
        segueToEdit()
    }
    
    func segueToEdit(){
        performSegue(withIdentifier: "EditEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEvent" {
            let addEventVC = segue.destination as! AddEventVC
            addEventVC.event = self.event.value
        }
    }


}
