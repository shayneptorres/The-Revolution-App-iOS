//
//  EventDetailActionBtnCell.swift
//  Rev FBC
//
//  Created by Shayne Torres on 9/24/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

enum EventDetailActionType {
    case signUp
    case delete
}

class EventDetailActionBtnCell: UITableViewCell {
    
    @IBOutlet weak var actionBtn: UIButton!
    
    func setUpBtnUI(type: EventDetailActionType) {
        switch type {
        case .signUp:
            actionBtn.setTitle("Sign up!", for: .normal)
            actionBtn.backgroundColor = #colorLiteral(red: 0.2666666667, green: 0.8588235294, blue: 0.368627451, alpha: 1)
            break
        case .delete:
            actionBtn.setTitle("Delete", for: .normal)
            actionBtn.backgroundColor = #colorLiteral(red: 1, green: 0.137254902, blue: 0, alpha: 1)
        }
        
    }
    
    
}
