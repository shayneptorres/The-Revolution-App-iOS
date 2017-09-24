//
//  RealmMigrationManager.swift
//  Rev FBC
//
//  Created by Shayne Torres on 9/24/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmMigrationManager {
    
    static let instance = RealmMigrationManager()
    
    private let schemaVersion : UInt64 = 0 // This must be updated everytime there is a new migration
    
    init() {
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
        })
    }
    
}
