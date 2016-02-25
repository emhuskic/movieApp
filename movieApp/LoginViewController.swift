//
//  LoginViewController.swift
//  movieApp
//
//  Created by Adis Cehajic on 25/02/16.
//  Copyright © 2016 EminaHuskic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginPressed(sender: AnyObject) {
        if (usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty)
        {
            print("Username or password field is empty");
        }
        else
        {
            getRequestToken();
        }
    }
    /*
NSURL *baseURL = [NSURL URLWithString:@"https://api.themoviedb.org"];
AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);

//IMAGES MAPPING
RKObjectMapping* movieMapping2 = [RKObjectMapping mappingForClass:[MOVMovie class]];
[movieMapping2 addAttributeMappingsFromDictionary:@{
}];
RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:movieMapping2 method:RKRequestMethodAny pathPattern:[NSString stringWithFormat:@"/3/search/movie"]  keyPath:@"results" statusCodes:statusCodes];*/
    
    func getRequestToken()
    {
     //   let url = NSURL
    }
}
