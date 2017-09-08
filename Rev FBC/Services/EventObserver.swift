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

protocol EventObserverDelegate {
    func update()
    var delegateID : Int? { get set }
}



class EventObserver {
    
    var table: UITableView?
    var events: [Event] = []
    var delegates : [EventObserverDelegate] = []
    
    static let instance = EventObserver()
    
    func startObserving() {
        FirebaseService.instance.observeEventChanges {
            self.delegates.forEach({ delegate in delegate.update() })
        }
    }
    
    func removeDelegate(id: Int){
        guard let index = delegates.index(where: { delegate in delegate.delegateID == id }) else { return }
        delegates.remove(at: index)
    }
    
    /// Place the realm event observer here
    
}
