//
//  AccountController.swift
//  movieApp
//
//  Created by Adis Cehajic on 24/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

import UIKit

class AccountController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchDown)
    }
    
    func buttonTapped(sender:UIButton!){
        performSegueWithIdentifier("loginSegue", sender: nil)
        
    }
}
