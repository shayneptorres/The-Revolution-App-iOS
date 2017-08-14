//
//  FirebaseService.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/13/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FirebaseService {
    
    static let instance = FirebaseService()
    
    func loginGuest() -> Promise<Bool> {
        
        return Promise<Bool>(work: { fulfill, reject in
            Auth.auth().signInAnonymously { (user, error) in
                guard user != nil else {
                    fulfill(false)
                    return
                }
                fulfill(true)
            }
        })
    }
    
    private func deleteOldEvents(ids: [String]){
        Event.getAll().forEach({ event in
            if !ids.contains(event.id) {
                event.delete()
            }
        })
    }

    func getUpcomingEvents() -> Promise<Bool> {
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-d-yyyy h:mma"
        var idsToKeep : [String] = []
        
            return Promise<Bool>(work: { fulfill, reject in
                ref.child("upcomingEvents").observe(.value, with: { (snap) in
                    guard let snapDicts = snap.value as? NSDictionary else { return }
                    
                    snapDicts.forEach({ snapDict in
                        let eventDict = snapDict.value as! NSDictionary
                        if
                            let key = snapDict.key as? String,
                            let name = eventDict["name"] as? String,
                            let desc = eventDict["desc"] as? String,
                            let address = eventDict["address"] as? String,
                            let dateStr = eventDict["startDate"] as? String {
                            
                            idsToKeep.append(key)
                            
                            /// If we already have this event saved then update the event
                            var e = Event.getAll().filter({ $0.id == key }).first
                            if e != nil {
                                e?.update {
                                    e?.name = name
                                    e?.desc = desc
                                    e?.address = address
                                    e?.startDate = dateFormatter.date(from: dateStr)!
                                }
                            } else {
                                /// Else create a new event and save it
                                var event = Event()
                                event.id = key
                                event.name = name
                                event.desc = desc
                                event.address = address
                                event.startDate = dateFormatter.date(from: dateStr)!
                                event.save()
                                
                            }
                        } else {
                            fulfill(false)
                        }
                    })
                    self.deleteOldEvents(ids: idsToKeep)
                    fulfill(true)
            })
        })
        
        
    }
}
