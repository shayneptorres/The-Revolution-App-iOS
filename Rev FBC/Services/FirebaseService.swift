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
import SwiftDate

typealias LocationDescTuple = (rev: String, fbc: String)

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
    
    
    func getLocationDescriptions() -> Promise<LocationDescTuple> {
        let ref = Database.database().reference()
        return Promise<LocationDescTuple>(work: { fulfill, reject in
            ref.child("mainLocationDescriptions").observeSingleEvent(of: .value, with: { snap in
                guard let snapDict = snap.value as? NSDictionary,
                    let revDesc = snapDict["revolution"] as? String,
                    let fbcDesc = snapDict["fbc"] as? String else {
                        fulfill((rev: "", fbc: ""))
                        return
                }
                
                let tup : LocationDescTuple = (rev: revDesc, fbc: fbcDesc)
                fulfill(tup)
            })
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
                print(snap)
                guard let snapDicts = snap.value as? NSDictionary else {
                    Event.getAll().forEach({ $0.delete() })
                    return
                }
                
                snapDicts.forEach({ snapDict in
                    let eventDict = snapDict.value as! NSDictionary
                    
                    let tempEvent = Event()
                    let key = snapDict.key as? String ?? ""
                    tempEvent.name = eventDict["name"] as? String ?? "No name"
                    tempEvent.desc = eventDict["desc"] as? String ?? "No description"
                    tempEvent.urlString = eventDict["website"] as? String ?? ""
                    tempEvent.signUpUrl = eventDict["signUpUrl"] as? String ?? ""
                    tempEvent.address = eventDict["address"] as? String ?? ""
                    tempEvent.locationName = eventDict["locationName"] as? String ?? ""
                    tempEvent.isSpecial = eventDict["isSpecial"] as? Bool ?? false
                    let endDateStr = eventDict["endDate"] as? String ?? ""
                    let startDateStr = eventDict["startDate"] as? String ?? ""
                    tempEvent.endDate = dateFormatter.date(from: endDateStr) ?? dateFormatter.date(from: "01-1-2001 1:00AM")!
                    tempEvent.startDate = dateFormatter.date(from: startDateStr) ?? dateFormatter.date(from: "01-1-2001 1:00AM")!
                    
                    if let date = dateFormatter.date(from: startDateStr) {
                        if date > Date() + 2.hours {
                            idsToKeep.append(key)
                        }
                    }
                    
                    self.handleResponse(event: tempEvent, key: key ?? "")
                    self.deleteOldEvents(ids: idsToKeep)
                    fulfill(true)
                })
            })
        })
        
    }
    
    func handleResponse(event: Event, key: String) {
        /// If we already have this event saved then update the event
        var e = Event.getAll().filter({ $0.id == key }).first
        if e != nil {
            e?.update {
                e?.name = event.name
                e?.desc = event.desc
                e?.address = event.address
                e?.signUpUrl = event.signUpUrl
                e?.locationName = event.locationName
                e?.urlString = event.urlString
                e?.isSpecial = event.isSpecial
                e?.startDate = event.startDate
                e?.endDate = event.endDate
            }
        } else {
            /// Else create a new event and save it
            var newEvent = Event()
            newEvent.id = key
            newEvent.name = event.name
            newEvent.desc = event.desc
            newEvent.urlString = event.urlString
            newEvent.signUpUrl = event.signUpUrl
            newEvent.locationName = event.locationName
            newEvent.address = event.address
            newEvent.isSpecial = event.isSpecial
            newEvent.startDate = event.startDate
            newEvent.endDate = event.endDate
            newEvent.save()
        }
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
                
                let tempEvent = Event()
                let key = snapDict.key as? String ?? ""
                tempEvent.name = eventDict["name"] as? String ?? "No name"
                tempEvent.desc = eventDict["desc"] as? String ?? "No description"
                tempEvent.urlString = eventDict["website"] as? String ?? ""
                tempEvent.signUpUrl = eventDict["signUpUrl"] as? String ?? ""
                tempEvent.address = eventDict["address"] as? String ?? ""
                tempEvent.locationName = eventDict["locationName"] as? String ?? ""
                tempEvent.isSpecial = eventDict["isSpecial"] as? Bool ?? false
                let endDateStr = eventDict["endDate"] as? String ?? ""
                let startDateStr = eventDict["startDate"] as? String ?? ""
                tempEvent.endDate = dateFormatter.date(from: endDateStr) ?? dateFormatter.date(from: "01-1-2001 1:00AM")!
                tempEvent.startDate = dateFormatter.date(from: startDateStr) ?? dateFormatter.date(from: "01-1-2001 1:00AM")!
                
                if let date = dateFormatter.date(from: startDateStr) {
                    if date > Date() + 2.hours {
                        idsToKeep.append(key)
                    }
                }
                
                self.handleResponse(event: tempEvent, key: key ?? "")
                self.deleteOldEvents(ids: idsToKeep)
                idsToKeep.removeAll()
                completion()
            })
        })
    }
    
    func addEvent(event: Event) {
        let ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM-d-yyyy h:mma"
        
        let eventDict : Dictionary<String,Any> = ["name":event.name as NSString,
                                                  "address":event.address as NSString,
                                                  "locationName":event.locationName as NSString,
                                                  "signUpUrl":event.signUpUrl as NSString,
                                                  "desc":event.desc as NSString,
                                                  "website":event.urlString as NSString,
                                                  "isSpecial":event.isSpecial as Bool,
                                                  "startDate":dateFormatter.string(from: event.startDate) as NSString,
                                                  "endDate":dateFormatter.string(from: event.endDate) as NSString,
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
                                                  "locationName":event.locationName as NSString,
                                                  "signUpUrl":event.signUpUrl as NSString,
                                                  "website":event.urlString as NSString,
                                                  "desc":event.desc as NSString,
                                                  "isSpecial":event.isSpecial as Bool,
                                                  "startDate":dateFormatter.string(from: event.startDate) as NSString,
                                                  "endDate":dateFormatter.string(from: event.endDate) as NSString
        ]
        
        ref.child("upcomingEvents/\(event.id)").setValue(eventDict)
    }
}

