//
//  SlideableMenuVC.swift
//  Rev FBC
//
//  Created by Shayne Torres on 8/6/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import UIKit

class SlideableMenuVC: UIViewController, SlideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        addSlideMenuButton()
    }
    
    func menuItemSelected(atIndex index: Int) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("Home")
            
            break
        case 1:
            print("Play\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("PlayVC")
            
            break
        default:
            print("default\n", terminator: "")
        }
    }

    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    var btnShowMenu : UIButton?
    
    func addSlideMenuButton(){
        btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu?.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu?.addTarget(self, action: #selector(self.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        
        let customBarItem = UIBarButtonItem(customView: btnShowMenu!)
        
        navigationItem.leftBarButtonItem = customBarItem;
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func closeMenu(){
        // To Hide Menu If it already there
        self.menuItemSelected(atIndex: -1);
        btnShowMenu?.tag = 0
        let viewMenuBack : UIView = view.subviews.last!
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            var frameMenu : CGRect = viewMenuBack.frame
            frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
            viewMenuBack.frame = frameMenu
            viewMenuBack.layoutIfNeeded()
            viewMenuBack.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            viewMenuBack.removeFromSuperview()
        })
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        
        if (sender.tag == 10)
        {
            closeMenu()
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
        
        let menuVC = menuStoryboard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        //        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width * 0.75, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }

}
