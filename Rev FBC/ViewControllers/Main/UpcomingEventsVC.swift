//
//  UpcomingEventsVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class UpcomingEventsVC: SlideableMenuVC {
    
    var events : [Event] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseService.instance.loginGuest().then({ loginSuccess in
            if loginSuccess {
                FirebaseService.instance.getUpcomingEvents().then({ success in
                    self.events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
                    self.tableView.reloadData()
                })
            }
        })
    }
    

}

extension UpcomingEventsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
}
