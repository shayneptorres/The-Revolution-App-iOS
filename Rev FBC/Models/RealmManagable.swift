//
//  RealmManagable.swift
//  Ministry Hub
//
//  Created by Shayne Torres on 7/24/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import RealmSwift
import Realm

protocol RealmManagable {
    
    var id : String { get set }
    var createdAt : Date { get set }
    var updatedAt : Date { get set }
    
    associatedtype RealmObject
    
    //    func save()
    //    func update(completion: ()->())
    //    func getAll() -> [Object]?
    //    func getOne() -> Object?
    //    func getOne(withId id: Int) -> Object?
}

extension RealmManagable where Self : Object {
    
    mutating func save(){
        let realm = try! Realm()
        try! realm.write {
            self.createdAt = Date()
            self.updatedAt = Date()
            realm.add(self)
        }
    }
    
    mutating func update(completion: () -> ()){
        let realm = try! Realm()
        try! realm.write {
            completion()
            self.updatedAt = Date()
            realm.add(self, update: true)
        }
    }
    
    func delete(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    static func getAll() -> [RealmObject] {
        let realm = try! Realm()
        return realm.objects(RealmObject.self as! Object.Type).map({ obj in (obj as? RealmObject)! })
    }
    
    static func getOne(withId id: String) -> RealmObject? {
        let realm = try! Realm()
        
        return realm.objects(RealmObject.self as! Object.Type).filter("id == \(id)").first as? RealmObject
    }
    
    func getOne() -> Object? {
        return nil
    }
    
}

