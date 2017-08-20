//
//  EventObserver.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/18/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import UIKit

class EventObserver {
    
    var table: UITableView?
    var events: [Event] = []
    
    init(tableView: UITableView, events: [Event]){
        self.table = tableView
        self.events = events
        startObserving()
    }
    
    func startObserving() {
        FirebaseService.instance.observeEventChanges {
            self.events = Event.getAll().sorted(by: { $0.startDate < $1.startDate })
            print(self.events)
            self.table?.reloadData()
            print("events reloaded")
        }
    }
    
}
