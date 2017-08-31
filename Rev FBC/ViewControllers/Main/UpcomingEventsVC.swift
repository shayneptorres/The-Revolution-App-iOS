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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableViewAutomaticDimension
            
            tableView.separatorStyle = .none
            
            
            let nib = UINib(nibName: "UpcomingEventCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: CellID.upcomingEvent.rawValue)
        }
    }
    
    @IBOutlet weak var addEventBtn: UIBarButtonItem! {
        didSet {
            addEventBtn.tintColor = UIColor(netHex: 0xF0C930)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
        tableView.reloadData()
        
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
        
        FirebaseService.instance.loginGuest().then({ loginSuccess in
            if loginSuccess {
                FirebaseService.instance.getUpcomingEvents().then({ success in
                    self.resetEvents()
                })
            }
        })
        
        /// Start observing upcoming events
        observer = EventObserver(tableView: tableView, events: events)
        
        
    }
    
    func resetEvents(){
        self.events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
        self.tableView.reloadData()
    }
    
    
    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        goToEventForm()
    }
    
    func goToEventForm(){
        performSegue(withIdentifier: "AddEvent", sender: self)
    }
    

}

// MARK: - Navigation
extension UpcomingEventsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetail" {
            guard let detailVC = segue.destination as? UpcomingEventDetailVC else { return }
            detailVC.event = Variable<Event?>(selectedEvent)
        } else if segue.identifier == "AddEvent" {
        
        }
    }
}

// MARK: - TableView Delegate/Datasource
extension UpcomingEventsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let eventCell = tableView.dequeueReusableCell(withIdentifier: CellID.upcomingEvent.rawValue) as! UpcomingEventCell
        eventCell.event = events[indexPath.row]
        cell = eventCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "EventDetail", sender: self)
    }
    
}
