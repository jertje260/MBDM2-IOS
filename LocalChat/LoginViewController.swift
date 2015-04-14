//
//  ViewController.swift
//  LocalChat
//
//  Created by Jeroen Broekhuizen on 06/03/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var ErrorMsg: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false;
        self.navigationController?.navigationItem.hidesBackButton = true
        if let username = NSUserDefaults.standardUserDefaults().stringForKey("Username") {
            JsonParser.getUser(username) {(callback) in
                dispatch_async(dispatch_get_main_queue(), {
                    if (callback == "User set"){
                        self.navigationController?.navigationBarHidden = true;
                        self.performSegueWithIdentifier("LoggedIn", sender: nil)
                    } else {
                        self.ErrorMsg.text = callback
                    }
                })
            }
        }
    }
    
    @IBAction func login(sender :UIButton){
        if(!loginName.text.isEmpty && !loginPassword.text.isEmpty){
            JsonParser.login(username: loginName.text, password: loginPassword.text) { (callback) in
                dispatch_async(dispatch_get_main_queue(), {
                    if let user = callback as? User {
                        self.loginPassword?.text = ""
                        self.loginName?.text = ""
                        self.ErrorMsg?.text = ""
                        self.navigationController?.navigationBarHidden = true;
                        self.performSegueWithIdentifier("LoggedIn", sender: nil)
                    } else if let msg = callback as? String{
                        self.loginPassword?.text = ""
                        self.loginName?.text = ""
                        self.ErrorMsg?.text = msg
                        self.ErrorMsg?.sizeToFit()
                    }
                })
            }
        }
        else {
            ErrorMsg.text = "Please fill out your Username and Password"
            ErrorMsg.sizeToFit()
        }
    }
}

