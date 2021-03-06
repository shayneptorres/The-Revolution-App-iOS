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
            
            +++ Section("")
            <<< ButtonRow() { row in
                row.title = "Save event"
                }.onCellSelection {_,_ in
                    
                    guard
                        let nameRow = self.form.rowBy(tag: "name") as? TextRow,
                        let infoRow = self.form.rowBy(tag: "info") as? TextAreaRow,
                        let websiteRow = self.form.rowBy(tag: "website") as? TextRow,
                        let specialRow = self.form.rowBy(tag: "special") as? SwitchRow,
                        let addressRow = self.form.rowBy(tag: "address") as? TextAreaRow,
                        let dateRow = self.form.rowBy(tag: "date") as? DateRow,
                        let startRow = self.form.rowBy(tag: "startTime") as? TimeRow
                        else { return }
                    
                    let name = nameRow.value ?? ""
                    let info = infoRow.value ?? ""
                    let website = websiteRow.value ?? ""
                    let address = addressRow.value ?? ""
                    let date = dateRow.value ?? Date()
                    let startTime = startRow.value ?? Date()
                    let special = specialRow.value ?? false
                    
                    var startDate = date.startOfDay
                    startDate = startDate + Int(startTime.hour).hours + Int(startTime.minute).minutes
                    print(startDate)
                    
                    let event = Event()
                    event.name = name
                    event.isSpecial = special
                    event.urlString = website
                    event.desc = info
                    event.address = address
                    event.startDate = startDate
                    
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

