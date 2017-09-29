//
//  UpcomingEventsVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import RxSwift
import KeychainAccess

class UpcomingEventsVC: SlideableMenuVC {
    
    var events : [Event] = []
    var selectedEvent: Event?
    var observer : EventObserver?
    var delegateID: Int?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableViewAutomaticDimension
            
            tableView.separatorStyle = .none
            
            
            var nib = UINib(nibName: "UpcomingEventCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: CellID.upcomingEvent.rawValue)
            
            nib = UINib(nibName: "UpcomingEventHeaderTableViewCell", bundle: nil)
            self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: CellID.upcomingEventHeaderCell.rawValue)
        }
    }
    
    @IBOutlet weak var addEventBtn: UIBarButtonItem! {
        didSet {
            addEventBtn.tintColor = UIColor(netHex: 0xF0C930)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAdminUISettings()
    }
    
    func updateAdminUISettings(){
        if AdminService.instance.getUserCredentials() == nil {
            navigationItem.rightBarButtonItem = nil
        } else {
            
            if navigationItem.rightBarButtonItem != nil { return }
            addEventBtn = UIBarButtonItem(image: UIImage.init(named: "addEventIcon"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(goToEventForm))
            
            let btn = UIBarButtonItem(image: UIImage.init(named: "addEventIcon"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(goToEventForm))
            
            btn.tintColor = UIColor(netHex: 0xF0C930)
            
            navigationItem.rightBarButtonItem = btn
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(netHex: 0xF0C930)
        self.events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
        self.tableView.reloadData()
        
        delegateID = EventObserver.instance.delegates.count
        EventObserver.instance.delegates.append(self)
        
        FirebaseService.instance.loginGuest().then({ loginSuccess in
            if loginSuccess {
                FirebaseService.instance.getUpcomingEvents().then({ success in
                    EventObserver.instance.startObserving()
                })
            }
        })
        
        NotificationService.instance.center.getPendingNotificationRequests { notifications in
            print("NOTIFICATIONS:")
            print(notifications)
        }
        
    }
    
    deinit {
        guard let id = delegateID else { return }
        EventObserver.instance.removeDelegate(id: id)
    }
    
    
    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        goToEventForm()
    }
    
    func goToEventForm(){
        performSegue(withIdentifier: "AddEvent", sender: self)
    }
    

}

extension UpcomingEventsVC : EventObserverDelegate {
    func update() {
        self.events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
        Event.getAll().forEach({ event in NotificationService.instance.checkNotifications(forEvent: event) })
        self.tableView.reloadData()
    }
}

// MARK: - Navigation
extension UpcomingEventsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetail" {
            guard let detailVC = segue.destination as? EventDetailVC else { return }
            detailVC.event = Variable<Event?>(selectedEvent).value
            
        } else if segue.identifier == "AddEvent" {
        
        }
    }
}

// MARK: - TableView Delegate/Datasource
extension UpcomingEventsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let specialEvents = events.filter({ $0.isSpecial }).sorted(by: { $0.startDate < $1.startDate })
        
        let regEvents = events.filter({ !$0.isSpecial }).sorted(by: { $0.startDate < $1.startDate })
        
        
        
        if section == 0 {
            return specialEvents.count
        } else {
            return regEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let specialEvents = events.filter({ $0.isSpecial }).sorted(by: { $0.startDate < $1.startDate })
        let regEvents = events.filter({ !$0.isSpecial }).sorted(by: { $0.startDate < $1.startDate })
        
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let eventCell = tableView.dequeueReusableCell(withIdentifier: CellID.upcomingEvent.rawValue) as! UpcomingEventCell
            eventCell.event = specialEvents[indexPath.row]
            cell = eventCell
        } else {
            let eventCell = tableView.dequeueReusableCell(withIdentifier: CellID.upcomingEvent.rawValue) as! UpcomingEventCell
            eventCell.event = regEvents[indexPath.row]
            cell = eventCell
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let specialEvents = events.filter({ $0.isSpecial }).sorted(by: { $0.startDate < $1.startDate })
        let regEvents = events.filter({ !$0.isSpecial }).sorted(by: { $0.startDate < $1.startDate })
        if indexPath.section == 0 {
            selectedEvent = specialEvents[indexPath.row]
        } else {
            selectedEvent = regEvents[indexPath.row]
        }
        
        performSegue(withIdentifier: "EventDetail", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let eventHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellID.upcomingEventHeaderCell.rawValue) as! UpcomingEventHeaderTableViewCell
        if section == 0 {
            eventHeader.headerNameLabel.text = "Special Events"
        } else {
            eventHeader.headerNameLabel.text = "Upcoming Events"
        }
        
        return eventHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
