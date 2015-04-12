//
//  LocalChatViewController.swift
//  LocalChat
//
//  Created by Sam van Dijk on 20/03/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//


import UIKit
import CoreLocation

class LocalChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
    private let MessageCellIdentifier = "MessageCell"
    private var MessagesModel = Array<Line>()
    private var timer : NSTimer? = nil
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Messages.delegate = self
        Messages.dataSource = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        loadMessages()
    }
    
    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "loadMessages", userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailView") {
            var destination = segue.destinationViewController as? UIViewController
            if let navCon = destination as? UINavigationController{
                destination = navCon.visibleViewController
            }
            if let dvc = destination as? DetailViewController {
                var messageIndex = Messages!.indexPathForSelectedRow()!.row
                var selectedMessage = self.MessagesModel[messageIndex]
                dvc.message = selectedMessage
            }
        }
    }
    

    
    
    // LocalChat screen
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendText: UITextField!
    @IBOutlet weak var Messages: UITableView!
    
    @IBAction func sendMessage(sender: UIButton!){
        var text = sendText.text
        sendText.text = ""
        
        
        //var
        
        // TODO
        // get gps pos and send to api
    }
    
    func loadMessages(){
        // temporary
        var lat = Double(51.9961)
        var long = Double(5.4555)
        
        JsonParser.getMessages(lat, longitude: long) { (callback) in
            dispatch_async(dispatch_get_main_queue(), {
                if let c = callback as? Array<Line> {
                    self.MessagesModel = c
                    self.Messages.reloadData()
                } else {
                    println("no message received")
                }
            })
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MessageCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = "\(MessagesModel[row].user!.displayName!) wrote:"
        cell.detailTextLabel?.text = "\(MessagesModel[row].message!)"
        return cell
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        println("update")
        println(locations)
    }
}

