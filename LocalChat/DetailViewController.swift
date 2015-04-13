//
//  DetailViewController.swift
//  LocalChat
//
//  Created by User on 09/04/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var message:Line?;
    
    @IBOutlet weak var MessageText: UILabel!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var DisplayName: UILabel!
    @IBOutlet weak var Moment: UILabel!
    @IBOutlet weak var Latitude: UILabel!
    @IBOutlet weak var Longitude: UILabel!
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (message != nil){
            loadViewData()
        }
    }
    
    func loadViewData(){
        MessageText.text = message!.message!
        Username.text = message!.user!.userName!
        DisplayName.text = message!.user!.displayName!
        var dateForm = NSDateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd hh:mm:ss"
        Moment?.text = "\(dateForm.stringFromDate(self.message!.moment!))"
        Latitude?.text = String(format:"%f", self.message!.Latitude!)
        Longitude?.text = String(format:"%f", self.message!.Longitude!)
    }    
}
