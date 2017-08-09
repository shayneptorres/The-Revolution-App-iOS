//
//  UpcomingEventsVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class UpcomingEventsVC: SlideableMenuVC {
    
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}

extension UpcomingEventsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let eventCell = tableView.dequeueReusableCell(withIdentifier: CellID.upcomingEvent.rawValue) as! UpcomingEventCell
        
        return eventCell
    }
    
}
