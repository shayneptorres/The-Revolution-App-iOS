//
//  MenuVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit
import KeychainAccess

protocol SlideMenuDelegate {
    func menuItemSelected(atIndex index: Int)
}

class MenuCell : UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
}

enum MenuAdminMode {
    case userAuthenticated
    case userUnauthenticated
}

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableViewAutomaticDimension
            
            tableView.separatorStyle = .none
            
            tableView.backgroundColor = UIColor(netHex: 0x222222)
        }
    }
    
    var delegate : SlideMenuDelegate?
    
    var adminMenuMode = MenuAdminMode.userUnauthenticated {
        didSet {
            tableView.reloadData()
        }
    }
    
    func didTap(){
        guard
            let upcomingVC = parent as? UpcomingEventsVC
            else { return }
        
        upcomingVC.closeMenu()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard
            let upcomingVC = parent as? UpcomingEventsVC
            else { return }
        upcomingVC.view.removeGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if AdminService.instance.getUserCredentials() == nil {
            adminMenuMode = .userUnauthenticated
        } else {
            adminMenuMode = .userAuthenticated
        }
    }
    
    var tap = UITapGestureRecognizer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard
            let upcomingVC = parent as? UpcomingEventsVC
            else { return }
        
        // Do any additional setup after loading the view.
        tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        upcomingVC.view.addGestureRecognizer(tap)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        
        if adminMenuMode == .userAuthenticated {
            menuCell.itemName.text = "Sign out"
        } else {
            menuCell.itemName.text = "Admin Sign-in"
        }
        
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let sb = UIStoryboard(name: "Admin", bundle: nil)
            
            guard
                let adminNav = sb.instantiateViewController(withIdentifier: "AdminLoginNav") as? UINavigationController,
                self.navigationController?.childViewControllers[0] != nil,
                let upcomingVC = parent as? UpcomingEventsVC,
                let menuNav = upcomingVC.parent as? MenuNav
                else { return }
            
            if adminMenuMode == .userUnauthenticated {
                /// If the user is not yet logged in, take them to the login page
                upcomingVC.closeMenu()
                upcomingVC.present(adminNav, animated: true, completion:nil)
            } else {
                /// If the user is already logged in, attempt to sign the user out
                let signOutAlert = UIAlertController(title: "Sign out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                    AdminService.instance.resetUserCredentials()
                    self.adminMenuMode = .userUnauthenticated
                    upcomingVC.updateAdminUISettings()
                })
                
                let cancelAction = UIAlertAction(title: "Not yet", style: .cancel, handler: nil)
                signOutAlert.addAction(confirmAction)
                signOutAlert.addAction(cancelAction)
                self.present(signOutAlert, animated: true, completion: { _ in upcomingVC.closeMenu() })
            }
            
            
        }
    }

}

