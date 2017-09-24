//
//  AddEventVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/14/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import Eureka
import SwiftDate
import RxSwift

class AddEventVC: FormViewController {
    
    var event : Event?
    
    override func viewDidDisappear(_ animated: Bool) {
        event = nil
    }
    
    deinit {
        event = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
        
    }
    
    func setUpForm(){
        form
            +++ Section("What")
            <<< TextRow() { row in
                row.title = "Name:"
                row.tag = "name"
                row.value = event?.name
            }
            <<< TextRow() { row in
                row.title = "Website:"
                row.tag = "website"
                row.value = event?.urlString
            }
            <<< TextRow() { row in
                row.title = "Sign up url:"
                row.tag = "signUp"
                row.value = event?.signUpUrl
            }
            <<< TextAreaRow() { row in
                row.placeholder = "Info:"
                row.tag = "info"
                row.value = event?.desc
            }
            <<< SwitchRow("SwitchRow") { row in
                row.title = "Special Event"
                row.tag = "special"
                row.value = event?.isSpecial
            }
            
            +++ Section("Where")
            <<< TextRow() { row in
                row.title = "Location name:"
                row.tag = "locationName"
                row.value = event?.locationName
            }
            <<< TextAreaRow() { row in
                row.placeholder = "Address:"
                row.tag = "address"
                row.value = event?.address
            }
            
            +++ Section("When")
            <<< DateRow() { row in
                row.title = "Date:"
                row.tag = "date"
                row.value = event?.startDate
            }
            <<< TimeRow() { row in
                row.title = "Starts:"
                row.tag = "startTime"
                row.value = event?.startDate
            }
            <<< TimeRow() { row in
                row.title = "Ends:"
                row.tag = "endTime"
                row.value = event?.endDate
            }
            
            +++ Section("")
            <<< ButtonRow() { row in
                row.title = "Save event"
                }.onCellSelection {_,_ in
                    
                    guard
                        let nameRow = self.form.rowBy(tag: "name") as? TextRow,
                        let infoRow = self.form.rowBy(tag: "info") as? TextAreaRow,
                        let websiteRow = self.form.rowBy(tag: "website") as? TextRow,
                        let signUpRow = self.form.rowBy(tag: "signUp") as? TextRow,
                        let specialRow = self.form.rowBy(tag: "special") as? SwitchRow,
                        let locationNameRow = self.form.rowBy(tag: "locationName") as? TextRow,
                        let addressRow = self.form.rowBy(tag: "address") as? TextAreaRow,
                        let dateRow = self.form.rowBy(tag: "date") as? DateRow,
                        let startRow = self.form.rowBy(tag: "startTime") as? TimeRow,
                        let endRow = self.form.rowBy(tag: "endTime") as? TimeRow
                        else { return }
                    
                    let name = nameRow.value ?? ""
                    let info = infoRow.value ?? ""
                    let website = websiteRow.value ?? ""
                    let signUp = signUpRow.value ?? ""
                    let locationName = locationNameRow.value ?? ""
                    let address = addressRow.value ?? ""
                    let date = dateRow.value ?? Date()
                    let startTime = startRow.value ?? Date()
                    let endTime = endRow.value ?? Date()
                    let special = specialRow.value ?? false
                    
                    var startDate = date.startOfDay
                    startDate = startDate + Int(startTime.hour).hours + Int(startTime.minute).minutes
                    
                    var endDate = date.startOfDay
                    endDate = endDate + Int(endTime.hour).hours + Int(endTime.minute).minutes
                    
                    let event = Event()
                    event.name = name
                    event.isSpecial = special
                    event.urlString = website
                    event.signUpUrl = signUp
                    event.desc = info
                    event.locationName = locationName
                    event.address = address
                    event.startDate = startDate
                    event.endDate = endDate
                    
                    if self.event != nil {
                        event.id = (self.event?.id)!
                        FirebaseService.instance.updateEvent(event: event)
                    } else {
                        FirebaseService.instance.addEvent(event: event)
                    }
                    
                    self.navigationController?.popViewController(animated: true)
        }
    }

}

