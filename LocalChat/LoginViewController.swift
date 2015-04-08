//
//  ViewController.swift
//  LocalChat
//
//  Created by Jeroen Broekhuizen on 06/03/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = NSUserDefaults.standardUserDefaults().stringForKey("Username") {
            JsonParser.getUser(username)
            performSegueWithIdentifier("LoggedIn", sender: nil)
        }

        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender :UIButton){
        
        if(!loginName.text.isEmpty && !loginPassword.text.isEmpty){
            JsonParser.login(username: loginName.text, password: loginPassword.text) { (callback) in
                dispatch_async(dispatch_get_main_queue(), {
                    if let user = callback as? User {
                        self.loginPassword?.text = ""
                        self.loginName?.text = ""
                        self.ErrorMsg?.text = ""
                        self.performSegueWithIdentifier("LoggedIn", sender: nil)
                    } else if let msg = callback as? String{
                        self.loginPassword?.text = ""
                        self.loginName?.text = ""
                        self.ErrorMsg?.text = msg
                    }
                })
            }
        }
        else {
            ErrorMsg.text = "Please fill out your Username and Password"
        }
    }

    @IBOutlet weak var ErrorMsg: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginName: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    

    
}

