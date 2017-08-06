//
//  AppTabBarViewController.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/5/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
