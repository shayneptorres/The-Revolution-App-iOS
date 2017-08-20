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

class AddEventVC: FormViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
        +++ Section("What")
            <<< TextRow() { row in
                row.title = "Name:"
                row.tag = "name"
                
            }
            <<< TextAreaRow() { row in
                row.placeholder = "Info:"
                row.tag = "info"
            }
            
        +++ Section("Where")
            <<< TextAreaRow() { row in
                row.placeholder = "Address:"
                row.tag = "address"
            }
            
        +++ Section("When")
            <<< DateRow() { row in
                row.title = "Date:"
                row.tag = "date"
            }
            <<< TimeRow() { row in
                row.title = "Starts:"
                row.tag = "startTime"
            }
        
        +++ Section("")
            <<< ButtonRow() { row in
                row.title = "Save event"
            }.onCellSelection {_,_ in
                
                guard
                    let nameRow = self.form.rowBy(tag: "name") as? TextRow,
                    let infoRow = self.form.rowBy(tag: "info") as? TextAreaRow,
                    let addressRow = self.form.rowBy(tag: "address") as? TextAreaRow,
                    let dateRow = self.form.rowBy(tag: "date") as? DateRow,
                    let startRow = self.form.rowBy(tag: "startTime") as? TimeRow,
                    let name = nameRow.value,
                    let info = infoRow.value,
                    let address = addressRow.value,
                    let date = dateRow.value,
                    let startTime = startRow.value
                else { return }
                
                var startDate = date.startOfDay - 7.hours
                startDate = startDate + Int(startTime.hour).hours + Int(startTime.minute).minutes
                print(startDate)
                
                let event = Event()
                event.name = name
                event.desc = info
                event.address = address
                event.startDate = startDate
                
                FirebaseService.instance.addEvent(event: event)
                self.navigationController?.popViewController(animated: true)
            }
    }

}

