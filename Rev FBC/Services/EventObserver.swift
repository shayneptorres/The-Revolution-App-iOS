//
//  EventObserver.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/18/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxCocoa


class EventObserver {
    
    var table: UITableView?
    var events: [Event] = []
    
    init(tableView: UITableView, events: [Event], completion: @escaping ()->()){
        self.table = tableView
        self.events = events
        startObserving(completion: completion)
    }
    
    func startObserving(completion: @escaping ()->()) {
        FirebaseService.instance.observeEventChanges {
            completion()
        }
    }
    
    /// Place the realm event observer here
    
}
