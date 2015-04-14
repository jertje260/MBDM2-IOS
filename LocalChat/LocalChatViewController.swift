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
    private var lastLocation : CLLocation = CLLocation(latitude: 51.9961, longitude: 5.4555) // default location in case gps isnt functioning correctly
    var manager:CLLocationManager!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendText: UITextField!
    @IBOutlet weak var Messages: UITableView!
    
    
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
    
    override func viewDidAppear(animated: Bool) {
        scrollToBottom()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGPSManager()
        loadMessages()
    }
    
    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "loadMessages", userInfo: nil, repeats: true)
        scrollToBottom()
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer = nil
    }
    
    
    @IBAction func sendMessage(sender: UIButton!){
        var text = sendText.text
        sendText.text = ""
        var lat = Double(self.lastLocation.coordinate.latitude)
        var long = Double(self.lastLocation.coordinate.longitude)
        JsonParser.sendMessage(text, latitude: lat ,longitude: long ) {(callback) in
            dispatch_async(dispatch_get_main_queue(), {
                if (callback == "success") {
                    self.loadMessages()
                    self.scrollToBottom()
                } else {
                    println("something went wrong")
                }
            })
        }
    }
    
    func loadMessages(){
        JsonParser.getMessages(self.lastLocation.coordinate.latitude, longitude: self.lastLocation.coordinate.longitude) { (callback) in
            dispatch_async(dispatch_get_main_queue(), {
                if let c = callback as? Array<Line> {
                    self.MessagesModel = c
                    self.Messages.reloadData()
                    self.scrollToBottom()
                } else {
                    println("no message received")
                }
            })
        }
    }
    
    func scrollToBottom(){
        let sectionCount = Messages.numberOfSections()
        let rowsInLastSection = Messages.numberOfRowsInSection(sectionCount-1)
        if (rowsInLastSection != 0){
            let indexPath:NSIndexPath = NSIndexPath(forRow: rowsInLastSection-1, inSection: sectionCount-1)
            self.Messages.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
    }
    
    func setGPSManager(){
        Messages.delegate = self
        Messages.dataSource = self
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.distanceFilter = 50 // 50m
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    //table view methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MessageCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = "\(MessagesModel[row].user!.displayName!) wrote:"
        // tried wordwrapping into multiple lines, but needs custom cell...
        //cell.detailTextLabel?.numberOfLines = 5
        cell.detailTextLabel?.text = "\(MessagesModel[row].message!)"
        return cell
    }
    
    //location methods
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        if let lastLocation = locations.last as? CLLocation {
            println("update location")
            self.lastLocation = lastLocation
            println("\(lastLocation.coordinate.latitude):\(lastLocation.coordinate.longitude)")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
    
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            println("updating location")
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
            println("authorization not determined")
        case .Restricted, .Denied:
            println("restricted/denied")
        }
    }
}

