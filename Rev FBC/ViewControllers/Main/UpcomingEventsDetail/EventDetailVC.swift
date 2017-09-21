//
//  EventDetailVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 9/18/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {
    
    @IBOutlet weak var table: UITableView! {
        didSet {
            table.delegate = self
            table.dataSource = self
            
            table.rowHeight = UITableViewAutomaticDimension
            table.estimatedRowHeight = 200
            table.separatorStyle = .none
            
            
            // Register Nibs
            
            var nib = UINib(nibName: "EventDetailTitleCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: CellID.eventTitleCell.rawValue)
            
            nib = UINib(nibName: "EventDetailMapCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: CellID.eventMapCell.rawValue)
            
            nib = UINib(nibName: "EventDetailInfoCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: CellID.eventInfoCell.rawValue)
        }

    }
    
    var event : Event? {
        didSet {
            guard let e = event else { return }
            updateUI(event: e)
        }
    }
    
    func updateUI(event: Event) {
        table.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension EventDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AdminService.instance.getUserCredentials() == nil {
            // If user is not a logged in admin
            return 0
        } else {
            // If user is a logged in admin
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let mapCell = table.dequeueReusableCell(withIdentifier: CellID.eventMapCell.rawValue) as! EventDetailMapCell
            
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
}
