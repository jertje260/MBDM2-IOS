//
//  LocalChatViewController.swift
//  LocalChat
//
//  Created by Sam van Dijk on 20/03/15.
//  Copyright (c) 2015 Jeroen Broekhuizen. All rights reserved.
//


import UIKit

class LocalChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let MessageCellIdentifier = "MessageCell"
    private var MessagesModel = Array<Line>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Messages.delegate = self
        Messages.dataSource = self
        
        
       
        
        loadMessages()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "DetailView"){
            var destination = segue.destinationViewController as? UIViewController
            if let navCon = destination as? UINavigationController{
                destination = navCon.visibleViewController
            }
            if let dvc = destination as? DetailViewController {
                println("preparing for segue")
                var messageIndex = Messages!.indexPathForSelectedRow()!.row
                var selectedMessage = self.MessagesModel[messageIndex]
                println("\(selectedMessage.message!)")
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
        //testmessage
        var l = Line()
        l.moment = NSDate()
        l.message = "Testmessage"
        l.user = User()
        l.user?.displayName = "test"
        MessagesModel.append(l)
        var k = Line()
        k.moment = NSDate()
        k.message = "Testmessage2"
        k.user = User()
        k.user?.displayName = "test2"
        MessagesModel.append(k)
        
        
    }

    
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
        cell.detailTextLabel?.text = "\(MessagesModel[row].message!)"
        return cell
    }
}

