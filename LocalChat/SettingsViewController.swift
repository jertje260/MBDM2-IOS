//
//  SettingsViewController.swift
//  LocalChat
//
//  Created by User on 08/04/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true;
        loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var DisplaynameField: UITextField!
    @IBOutlet weak var RadiusSlider: UISlider!
    @IBOutlet weak var SliderLabel: UILabel!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    func loadUserData(){
        let preferences = NSUserDefaults.standardUserDefaults()
        UsernameLabel?.text = preferences.stringForKey("Username")
        DisplaynameField?.text = preferences.stringForKey("Displayname")
        RadiusSlider?.value = preferences.floatForKey("Radius")
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        SliderLabel.text = "\(currentValue) m"
    }
    
    @IBAction func Logout(sender: AnyObject) {
        NSUserDefaults.resetStandardUserDefaults()
        navigationController?.popViewControllerAnimated(true)
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
 
}