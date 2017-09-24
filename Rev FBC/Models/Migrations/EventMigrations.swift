//
//  EventMigrations.swift
//  Rev FBC
//
//  Created by Shayne Torres on 9/24/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

enum EventMigrations {
    case add_endDate_locationName_signUpUrl
}

extension EventMigrations {
    func migrationBlock(migration: Migration) {
        switch self {
            
        case .add_endDate_locationName_signUpUrl: // Schema Version 1
            migration.enumerateObjects(ofType: Event.className()) { old, new in
                let endDate = Date()
                let signUpUrl = ""
                let locationName = ""
                new!["endDate"] = endDate
                new!["signUpUrl"] = signUpUrl
                new!["locationName"] = locationName
            }
        }
        
    }
}
