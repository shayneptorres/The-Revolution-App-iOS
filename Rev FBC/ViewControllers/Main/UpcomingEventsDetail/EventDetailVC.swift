//
//  EventDetailVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 9/18/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct EventDetailVM : WebSiteManager, LocationManager {
    
    var event : Event?
    
    func webSiteBtnWasTapped() {
        guard let event = event else { return }
        showWebSite(url: event.url())
    }
    
    func directionsBtnWasTapped() {
        guard let event = event else { return }
        directions(event: event)
    }
    
}

class EventDetailVC: UIViewController, LocationManager {
    
    @IBOutlet weak var table: UITableView! {
        didSet {
            table.delegate = self
            table.dataSource = self
            
            table.rowHeight = UITableViewAutomaticDimension
            table.estimatedRowHeight = 200
            table.separatorStyle = .none
            
            
            // Register Nibs
            
            var nib = UINib(nibName: "EventDetailTitleCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: CellID.eventTitleCell.rawValue)
            
            nib = UINib(nibName: "EventDetailMapCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: CellID.eventMapCell.rawValue)
            
            nib = UINib(nibName: "EventDetailInfoCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: CellID.eventInfoCell.rawValue)
            
            nib = UINib(nibName: "EventDetailActionBtnCell", bundle: nil)
            table.register(nib, forCellReuseIdentifier: CellID.eventActionBtn.rawValue)
        }

    }
    
    var event : Event? {
        didSet {
            guard let e = event else { return }
            updateUI(event: e)
        }
    }
    
    var viewModel : EventDetailVM!
    
    var disposeBag = DisposeBag()
    
    func updateUI(event: Event) {
        guard let tv = table as? UITableView else { return }
        tv.reloadData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.reloadData()
        
        viewModel = EventDetailVM(event: event)
    }

}

extension EventDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let event = event else { return 0 }
        if event.signUpUrl != "" {
            return 2
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 5
        } else {
            return 1
        }
//
//        if AdminService.instance.getUserCredentials() == nil {
//            // If user is not a logged in admin
//            return 5
//        } else {
//            // If user is a logged in admin
//            return 5
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        guard let event = event, let vm = viewModel else { return UITableViewCell() }
        if indexPath.section == 0 {
            
            // Regular table cells
            switch indexPath.row {
            case 0: // Initial Map View Cell
                let mapCell = table.dequeueReusableCell(withIdentifier: CellID.eventMapCell.rawValue) as! EventDetailMapCell
                mapCell.selectionStyle = .none
                
                let tableWidth = table.bounds.width
                mapCell.overlayView.roundCornersForTableViewCell(corners: [.topLeft,.topRight],
                                                                 radii: 20,
                                                                 tableViewWidth: tableWidth,
                                                                 contentSpacing: 16)
                
                cell = mapCell
                
            case 1: // Title cell for event
                let titleCell = tableView.dequeueReusableCell(withIdentifier: CellID.eventTitleCell.rawValue) as! EventDetailTitleCell
                titleCell.eventTitleLabel.text = event.name
                titleCell.selectionStyle = .none
                cell = titleCell
                
            case 2: // When: Details about the time
                let infoCell = tableView.dequeueReusableCell(withIdentifier: CellID.eventInfoCell.rawValue) as! EventDetailInfoCell
                infoCell.categoryLabel.text = "When:"
                
                let startDateformatter = DateFormatter()
                startDateformatter.dateFormat = "EEE, MMM dd 'at' h:mm a"
                
                let endDateformatter = DateFormatter()
                endDateformatter.dateFormat = "h:mm a"
                
                infoCell.descLabel.text = "\(startDateformatter.string(from: event.startDate)) to \(endDateformatter.string(from: event.endDate))"
                infoCell.actionBtn.isHidden = true
                infoCell.selectionStyle = .none
                cell = infoCell
                
            case 3: // What: Details about the event
                let infoCell = tableView.dequeueReusableCell(withIdentifier: CellID.eventInfoCell.rawValue) as! EventDetailInfoCell
                infoCell.categoryLabel.text = "What:"
                infoCell.actionBtn.setTitle("Website", for: .normal)
                infoCell.descLabel.text = event.desc
                infoCell.selectionStyle = .none
                infoCell.actionBtn.rx
                    .tap
                    .subscribe(onNext:{
                        vm.webSiteBtnWasTapped()
                    }).addDisposableTo(disposeBag)
                
                cell = infoCell
                
            case 4: // Where: Details about where the event is at
                let infoCell = tableView.dequeueReusableCell(withIdentifier: CellID.eventInfoCell.rawValue) as! EventDetailInfoCell
                infoCell.categoryLabel.text = "Where:"
                infoCell.actionBtn.setTitle("Directions", for: .normal)
                infoCell.descLabel.text = "\(event.locationName)\n\(event.address)"
                infoCell.actionBtn.isHidden = false
                infoCell.selectionStyle = .none
                infoCell.actionBtn.rx
                    .tap
                    .subscribe(onNext: {
                        vm.directionsBtnWasTapped()
                    }).addDisposableTo(disposeBag)
                
                
                cell = infoCell
                
            default:
                return UITableViewCell()
            }
        } else {
            // Action cells
            
            switch indexPath.row {
            case 0: // Normally the sign up action btn
                let actionCell = tableView.dequeueReusableCell(withIdentifier: CellID.eventActionBtn.rawValue) as! EventDetailActionBtnCell
                actionCell.setUpBtnUI(type: .signUp)
                cell = actionCell
            default:
                return UITableViewCell()
            }
        }
        
        return cell
    }
    
}
