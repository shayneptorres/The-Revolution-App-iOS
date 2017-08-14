//
//  InfoVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/9/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import SwiftDate
import MapKit
import CoreLocation
import MessageUI

class InfoVC: UIViewController, CoordinateManager {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableViewAutomaticDimension
            
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor(netHex: 0xf3f3f3)
            
            // Register NIBs
            var nib = UINib(nibName: "LocationActionCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: CellID.locationActionCell.rawValue)
            
            nib = UINib(nibName: "LocationInfoCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: CellID.locationInfoCell.rawValue)
            
            nib = UINib(nibName: "LocationMapCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: CellID.locationMapCell.rawValue)
            
            nib = UINib(nibName: "LocationCell", bundle: nil)
            self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: CellID.locationCell.rawValue)
        }
    }
    
    typealias CollapsibleSection = (name: String, collapsed: Bool)
    
    var sections : [CollapsibleSection] = []
    
    var events : [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createWednesdayNightEvent()
        createSundayMorningEvent()
        tableView.reloadData()
        
    }
    
    func createWednesdayNightEvent(){
        let revolution = Event()
        revolution.name = "The Revolution"
        revolution.address = REV_FBC_ADDRESS
        revolution.desc = "Come join us for a night of fun, games, singing praise, and teaching God's word."
        
        // create a wednesday
        var wednesday = Date().startOfDay
        while wednesday.weekdayName != "Wednesday" {
            wednesday =  wednesday + 1.day
        }
        wednesday = wednesday + 19.hours
        
        revolution.startDate = wednesday
        
        events.append(revolution)
        sections.append((name: revolution.name, collapsed: true))
    }
    
    func createSundayMorningEvent(){
        let sundayFellowship = Event()
        sundayFellowship.name = "Sunday Morning Fellowship"
        sundayFellowship.address = FBC_ADDRESS
        sundayFellowship.desc = "Join us as we meet with our whole church for a time of praise, teaching, and community. Stick around after for our high school meeting."
        
        // create a wednesday
        var sunday = Date().startOfDay
        while sunday.weekdayName != "Sunday" {
            sunday = sunday + 1.day
        }
        sunday = sunday + 8.hours + 30.minutes
        
        sundayFellowship.startDate = sunday
        
        events.append(sundayFellowship)
        sections.append((name: sundayFellowship.name, collapsed: true))
    }

}

extension InfoVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].collapsed {
            // if the section is collaped, then only show one cell
            return 0
        } else {
            // if the section is not collapsed, show all the cells
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
            
        case 0:
            /// Location Info Cell
            let mapCell = tableView.dequeueReusableCell(withIdentifier: CellID.locationMapCell.rawValue) as! LocationMapCell
            
            mapCell.event = events[indexPath.section]
            cell = mapCell
            
        case 1:
            /// Location Action Cell
            let actionCell = tableView.dequeueReusableCell(withIdentifier: CellID.locationActionCell.rawValue) as! LocationActionCell
            
            actionCell.event = events[indexPath.section]
            actionCell.delegate = self
            cell = actionCell
            
        case 2:
            /// Location Info Cell
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CellID.locationInfoCell.rawValue) as! LocationInfoCell
            
            infoCell.info.text = events[indexPath.section].desc
            cell = infoCell
        default:
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let locationCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellID.locationCell.rawValue) as! LocationCell

        locationCell.event = events[section]
        locationCell.section = section
        locationCell.delegate = self
        return locationCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
}

extension InfoVC : LocationCellDelegate {

    func handleTap(section: Int) {
        sections[section].collapsed = !sections[section].collapsed
        let indexSet = NSIndexSet.init(index: section)
        
        tableView.reloadSections(indexSet as IndexSet, with: .automatic)
    }
}

extension InfoVC : LocationAddressCellDelegate {
    func contact(event: Event) {
        
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
    
    func sendAddress(event: Event) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Address for \(event.name):\n\(event.address)"
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
    
    func website(event: Event) {
        
    }
}

extension InfoVC : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
