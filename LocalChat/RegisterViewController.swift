//
//  RegisterViewController.swift
//  LocalChat
//
//  Created by User on 12/04/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var RetypePasswordField: UITextField!


    @IBAction func RegisterUser(sender: AnyObject) {
        if(UsernameField.text != "" && PasswordField.text != "" && PasswordField != ""){
            if(PasswordField.text == RetypePasswordField.text){
                JsonParser.addUser(UsernameField.text, password:PasswordField.text){ (callback) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if let user = callback as? User {
                            self.UsernameField?.text = ""
                            self.PasswordField?.text = ""
                            self.RetypePasswordField?.text = ""
                            self.ErrorLabel?.text = ""
                            self.navigationController?.popViewControllerAnimated(false)
                            self.performSegueWithIdentifier("Register", sender: nil)
                        } else if let msg = callback as? String{
                            self.UsernameField?.text = ""
                            self.PasswordField?.text = ""
                            self.RetypePasswordField?.text = ""
                            self.ErrorLabel?.text = msg
                            self.ErrorLabel?.sizeToFit()
                        }
                    })
                
                }
            } else {
                ErrorLabel.text = "Your passwords are not the same."
            }
        } else {
            ErrorLabel.text = "Please fill out all fields"
        }
    }
}
