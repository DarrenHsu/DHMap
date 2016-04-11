//
//  BaseViewController.swift
//  DHMap
//
//  Created by Dareen Hsu on 4/8/16.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController, SlideNavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- SlideNavigationControllerDelegate Methods
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }

    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }

    func showAlert(message : String?) {
        let alert : UIAlertController = UIAlertController.init(title: "Action", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let callaction = UIAlertAction(title: "ok",style: .Default, handler: nil);

        alert.addAction(callaction)
        presentViewController(alert, animated: true, completion: nil)
    }
}