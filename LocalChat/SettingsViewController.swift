//
//  SettingsViewController.swift
//  LocalChat
//
//  Created by User on 08/04/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var DisplaynameField: UITextField!
    @IBOutlet weak var RadiusSlider: UISlider!
    @IBOutlet weak var SliderLabel: UILabel!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
    }

    
    func loadUserData(){
        let preferences = NSUserDefaults.standardUserDefaults()
        UsernameLabel?.text = preferences.stringForKey("Username")
        DisplaynameField?.text = preferences.stringForKey("Displayname")
        RadiusSlider?.value = preferences.floatForKey("Radius")
        SliderLabel.text = preferences.stringForKey("Radius")
    }
    
    @IBAction func Logout(sender: AnyObject) {
        let preferences = NSUserDefaults.standardUserDefaults()
        preferences.removeObjectForKey("UserID")
        preferences.removeObjectForKey("Username")
        preferences.removeObjectForKey("Displayname")
        preferences.removeObjectForKey("Radius")
        preferences.synchronize()
        performSegueWithIdentifier("Logout", sender: nil)
    }
    
    @IBAction func SaveChanges(sender: AnyObject) {
        if(PasswordField.text == ConfirmPasswordField.text){
            
            let preferences = NSUserDefaults.standardUserDefaults()

            preferences.setObject(DisplaynameField.text, forKey: "Displayname")
            preferences.setObject(Int(RadiusSlider.value), forKey: "Radius")
            preferences.synchronize()
            
            var user = User()
            user.ID = preferences.stringForKey("UserId")
            user.userName = preferences.stringForKey("Username")
            user.displayName = preferences.stringForKey("Displayname")
            user.radius = preferences.integerForKey("Radius")
            user.password = PasswordField.text
            JsonParser.saveUser(user)
            ErrorLabel.text = "Saved your settings"
        } else {
            ErrorLabel.text = "Password and Confirm Password are not the same"
        }
        
    }
     @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        SliderLabel.text = "\(currentValue) m"
    }
}