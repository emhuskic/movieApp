//
//  AccountController.swift
//  movieApp
//
//  Created by Adis Cehajic on 27/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

import UIKit
class AccountController: UIViewController {
    
    @IBOutlet weak var logButton: UIButton!
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if loggedIn==false
        {
            //loggedIn=true;
            performSegueWithIdentifier("loginSegue", sender: nil)
        }
        else
        {
            logButton.setTitle("Log In", forState: UIControlState.Normal)
            loggedIn=false;
            NSNotificationCenter.defaultCenter().postNotificationName("LoggedOut", object: nil)
        }

    }
    var loggedIn: Bool = false
    func loginChange(notification: NSNotification){
        loggedIn=true;
    }
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginChange:", name:"LogInSuccessful", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "LogInOut:",
            name: "LoggedIn",
            object: nil)
    }
    func LogInOut(notification: NSNotification){
        if loggedIn==false
        {
            logButton.setTitle("Log In", forState: UIControlState.Normal)
        }
        else
        {
            logButton.setTitle("Log Out", forState: UIControlState.Normal)
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if loggedIn==true
        {
           logButton.setTitle("Log Out", forState: UIControlState.Normal)
        }
        else
        {
            logButton.setTitle("Log In", forState: UIControlState.Normal)
            
        }
        
    }
}


