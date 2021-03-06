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

class InfoVC: UIViewController, LocationManager {
    
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
    
    var revDesc = "Join us every Wednesday night for games, singing, and spending time in Gods word."
    var fbc = "Join us on Sunday Mornings as we meet at 8:30am with our whole church body in time of singing, hearing from God's word, and fellowship with the body of Christ."

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createWednesdayNightEvent()
        self.createSundayMorningEvent()
        tableView.reloadData()
        FirebaseService.instance.getLocationDescriptions().then({ tup in
            if tup.rev != "" {
                self.events[0].desc = tup.rev
            }
            
            if tup.fbc != "" {
                self.events[1].desc = tup.fbc
            }
            
        })
    }
    
    func createWednesdayNightEvent(){
        let revolution = Event()
        revolution.name = "The Revolution"
        revolution.address = REV_FBC_ADDRESS
        revolution.desc = revDesc
        
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
        sundayFellowship.desc = fbc
        
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
        let email = "morgan@faith-bible.net"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
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
        var webSite = ""
        if event.name == "The Revolution" {
            webSite = "http://www.revfbc.net/"
        } else {
            webSite = "https://www.faith-bible.net/"
        }
        if let url = URL(string: webSite) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

extension InfoVC : MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
