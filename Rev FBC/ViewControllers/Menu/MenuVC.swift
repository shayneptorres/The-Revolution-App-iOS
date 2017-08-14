//
//  MenuVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func menuItemSelected(atIndex index: Int)
}

class MenuCell : UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
}

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableViewAutomaticDimension
            
            tableView.separatorStyle = .none
            
            tableView.backgroundColor = .lightGray
        }
    }
    
    var delegate : SlideMenuDelegate?
    
    var menuItems : [String] = ["Admin sign-in"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        menuCell.itemName.text = menuItems[indexPath.row]
        return menuCell
    }

}

