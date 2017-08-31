//
//  UpcomingEventsDetailVM.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/25/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation

class UpcomingEventsDetailVM {
    
    typealias Callback = (State) -> ()
    
    struct State {
    
    }
    
    var callback : Callback
    
    var state : State = State() {
        didSet {
        
        }
    }
    
    init(cb: @escaping Callback) {
        self.callback = cb
        callback(state)
    }
    
}
