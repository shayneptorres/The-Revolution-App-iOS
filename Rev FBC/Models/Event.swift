//
//  Event.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Event : Object, RealmManagable {
    dynamic var id = String()
    dynamic var name = String()
    dynamic var desc = String()
    dynamic var createdAt = Date()
    dynamic var updatedAt = Date()
    
    typealias RealmObject = Event
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
