//
//  InfoVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/9/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import SwiftDate

class InfoVC: UIViewController {
    
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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let actionCell = tableView.dequeueReusableCell(withIdentifier: CellID.locationActionCell.rawValue) as! LocationActionCell
            
            actionCell.event = events.first!
            cell = actionCell
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
        return 175
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
        
    }
    
    func sendAddress(event: Event) {
        
    }
    
    func website(event: Event) {
        
    }
}
