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
    
    func loginUser(email: String, password: String) -> Promise<Bool> {
        return Promise<Bool>(work: { fulfill, reject in
            Auth.auth().signIn(withEmail: email, password: password) { (user,error) in
                print("USER: ",user)
                print("ERROR: ",error)
                guard user != nil else {
                    fulfill(false)
                    return
                }
                fulfill(true)
            }
        })
    }
    
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
        let events = Event.getAll()
        let deletingEvents = events.filter({ e in !ids.contains(e.id) })
        deletingEvents.forEach({ e in e.delete() })
    }

    func getUpcomingEvents() -> Promise<Bool> {
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-d-yyyy h:mma"
        var idsToKeep : [String] = []
        
            return Promise<Bool>(work: { fulfill, reject in
                ref.child("upcomingEvents").observeSingleEvent(of: .value, with: { (snap) in
                    guard let snapDicts = snap.value as? NSDictionary else {
                        Event.getAll().forEach({ $0.delete() })
                        return
                    }
                    
                    snapDicts.forEach({ snapDict in
                        let eventDict = snapDict.value as! NSDictionary
                        if
                            let key = snapDict.key as? String,
                            let name = eventDict["name"] as? String,
                            let desc = eventDict["desc"] as? String,
                            let website = eventDict["website"] as? String,
                            let address = eventDict["address"] as? String,
                            let isSpecial = eventDict["isSpecial"] as? Bool,
                            let dateStr = eventDict["startDate"] as? String {
                            
                            idsToKeep.append(key)
                            
                            /// If we already have this event saved then update the event
                            var e = Event.getAll().filter({ $0.id == key }).first
                            if e != nil {
                                e?.update {
                                    e?.name = name
                                    e?.desc = desc
                                    e?.address = address
                                    e?.urlString = website
                                    e?.isSpecial = isSpecial
                                    e?.startDate = dateFormatter.date(from: dateStr)!
                                }
                            } else {
                                /// Else create a new event and save it
                                var event = Event()
                                event.id = key
                                event.name = name
                                event.desc = desc
                                event.urlString = website
                                event.address = address
                                event.isSpecial = isSpecial
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
    
    func observeEventChanges(completion: @escaping () -> ()) {
        
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-d-yyyy h:mma"
        var idsToKeep : [String] = []
        
        ref.child("upcomingEvents").observe(.value, with: { (snap) in
            guard let snapDicts = snap.value as? NSDictionary else {
                Event.getAll().forEach({ $0.delete() })
                return
            }
            print("SNAPS: ",snapDicts)
            snapDicts.forEach({ snapDict in
                
                
                
                let eventDict = snapDict.value as! NSDictionary
                if
                    let key = snapDict.key as? String,
                    let name = eventDict["name"] as? String,
                    let desc = eventDict["desc"] as? String,
                    let address = eventDict["address"] as? String,
                    let website = eventDict["website"] as? String,
                    let isSpecial = eventDict["isSpecial"] as? Bool,
                    let dateStr = eventDict["startDate"] as? String {
                    
                    idsToKeep.append(key)
                    
                    /// If we already have this event saved then update the event
                    var e = Event.getAll().filter({ $0.id == key }).first
                    if e != nil {
                        e?.update {
                            e?.name = name
                            e?.desc = desc
                            e?.address = address
                            e?.isSpecial = isSpecial
                            e?.urlString = website
                            e?.startDate = dateFormatter.date(from: dateStr)!
                            
                        }
                    } else {
                        /// Else create a new event and save it
                        var event = Event()
                        event.id = key
                        event.name = name
                        event.desc = desc
                        event.isSpecial = isSpecial
                        event.urlString = website
                        event.address = address
                        event.startDate = dateFormatter.date(from: dateStr)!
                        event.save()
                        
                    }
                } else {
                }
            })
            
            self.deleteOldEvents(ids: idsToKeep)
            idsToKeep.removeAll()
            completion()
        })
    }
    
    func addEvent(event: Event) {
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM-d-yyyy h:mma"

        let eventDict : Dictionary<String,Any> = ["name":event.name as NSString,
                                        "address":event.address as NSString,
                                        "desc":event.desc as NSString,
                                        "website":event.urlString as NSString,
                                        "isSpecial":event.isSpecial as Bool,
                                        "startDate":dateFormatter.string(from: event.startDate) as NSString
                                        ]
        let key = ref.child("upcomingEvents").childByAutoId().key as NSString
        
        ref.child("upcomingEvents/\(key)").setValue(eventDict)
        
    }
    
    func deleteEvent(event: Event){
        let ref = Database.database().reference()
        ref.child("upcomingEvents/\(event.id)").removeValue()
    }
    
    func updateEvent(event: Event){
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM-d-yyyy h:mma"
        let key = ref.child("upcomingEvents").childByAutoId().key as NSString
        
        
        let eventDict : Dictionary<String,Any> = ["name":event.name as NSString,
                                                  "address":event.address as NSString,
                                                  "website":event.urlString as NSString,
                                                  "desc":event.desc as NSString,
                                                  "isSpecial":event.isSpecial as Bool,
                                                  "startDate":dateFormatter.string(from: event.startDate) as NSString
        ]
        
        ref.child("upcomingEvents/\(event.id)").setValue(eventDict)
    }
}
