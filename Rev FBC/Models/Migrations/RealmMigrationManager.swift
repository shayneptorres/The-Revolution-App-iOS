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
    
    private let schemaVersion : UInt64 = 1 // This must be updated everytime there is a new migration
    
    init() {
        // When this singleton is instantiated, configure the new schema and run the provided migrations    
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 {
                let eventMigration = EventMigrations.add_endDate_locationName_signUpUrl
                eventMigration.migrationBlock(migration: migration)
            }
            
        })
        
        // This needs to be called so that realm will migrate the data
        Realm.Configuration.defaultConfiguration = config
    }
    
}
