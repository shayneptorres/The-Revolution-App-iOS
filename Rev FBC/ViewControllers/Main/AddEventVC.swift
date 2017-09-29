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
    
    let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
        
        if AdminService.instance.getUserCredentials() != nil && event != nil {
            let btn = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(self.delete(_:)))
            btn.tintColor = UIColor.red
            navigationItem.rightBarButtonItem = btn
            btn.rx.tap.subscribe(onNext: {
                print("Will delete")
                self.navigationController?.popToRootViewController(animated: true)
                guard let eventToDelete = self.event else { return }
                FirebaseService.instance.deleteEvent(event: eventToDelete)
            }).addDisposableTo(disposebag)
        }
    }
    
    func delete(){
        print("Will delete")
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
                row.cell.textField.autocapitalizationType = .none
            }
            <<< TextRow() { row in
                row.title = "Sign up url:"
                row.tag = "signUp"
                row.value = event?.signUpUrl
                row.cell.textField.autocapitalizationType = .none
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
                row.title = "Start Date:"
                row.tag = "startDate"
                row.value = event?.startDate
                }.onCellSelection({cell,row in
                    row.value = Date()
                })
            <<< TimeRow() { row in
                row.title = "Starts:"
                row.tag = "startTime"
                row.value = event?.startDate
                }.onCellSelection({cell,row in
                    row.value = Date()
                })
            <<< DateRow() { row in
                row.title = "End Date:"
                row.tag = "endDate"
                row.value = event?.endDate
                }.onCellSelection({cell,row in
                    row.value = Date()
                })
            <<< TimeRow() { row in
                row.title = "Ends:"
                row.tag = "endTime"
                row.value = event?.endDate
                }.onCellSelection({cell,row in
                    row.value = Date()
                })
            
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
                        let startDateRow = self.form.rowBy(tag: "startDate") as? DateRow,
                        let endDateRow = self.form.rowBy(tag: "endDate") as? DateRow,
                        let startRow = self.form.rowBy(tag: "startTime") as? TimeRow,
                        let endRow = self.form.rowBy(tag: "endTime") as? TimeRow
                        else { return }
                    
                    let name = nameRow.value ?? ""
                    let info = infoRow.value ?? ""
                    let website = websiteRow.value ?? ""
                    let signUp = signUpRow.value ?? ""
                    let locationName = locationNameRow.value ?? ""
                    let address = addressRow.value ?? ""
                    let startDate = startDateRow.value ?? Date()
                    let startTime = startRow.value ?? Date()
                    let endDate = endDateRow.value ?? Date()
                    let endTime = endRow.value ?? Date()
                    let special = specialRow.value ?? false
                    
                    var eventStartDate = startDate.startOfDay - 7.hours
                    eventStartDate = eventStartDate + Int(startTime.hour).hours + Int(startTime.minute).minutes
                    
                    var eventEndDate = endDate.startOfDay - 7.hours
                    eventEndDate = eventEndDate + Int(endTime.hour).hours + Int(endTime.minute).minutes
                    
                    let event = Event()
                    event.name = name
                    event.isSpecial = special
                    event.urlString = website
                    event.signUpUrl = signUp
                    event.desc = info
                    event.locationName = locationName
                    event.address = address
                    event.startDate = eventStartDate
                    event.endDate = eventEndDate
                    
                    
                    
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

