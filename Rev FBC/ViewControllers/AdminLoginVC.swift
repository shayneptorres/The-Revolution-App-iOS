//
//  AdminLoginVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/23/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class AdminLoginVM {
    
    struct State {
        
    }
    
    typealias Completion = (State) -> (Void)
    
    var callback : Completion!
    
    var state : State = State() {
        didSet {
            callback(state)
        }
    }
    
    init(cb: @escaping Completion){
        self.callback = cb
        callback(state)
    }
    
}

class AdminLoginVC: UIViewController {
    
    var viewModel : AdminLoginVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AdminLoginVM(cb: { state in
            // Set the view state here
        })
        
    }
}
