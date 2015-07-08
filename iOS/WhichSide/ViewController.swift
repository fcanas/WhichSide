//
//  ViewController.swift
//  WhichSide
//
//  Created by Fabian Canas on 7/5/15.
//  Copyright (c) 2015 Fabián Cañas. All rights reserved.
//

import UIKit

let IntervalCellIdentifier = "IntervalCell"

let dateFormatter = NSDateFormatter()

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView :UITableView!
    @IBOutlet var headerView :UIView!
    
    var events = Array<Event>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        tableView.registerNib(UINib(nibName: EventCellIdentifier, bundle: nil), forCellReuseIdentifier: EventCellIdentifier)
        tableView.registerNib(UINib(nibName: IntervalCellIdentifier, bundle: nil), forCellReuseIdentifier: IntervalCellIdentifier)
        
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
        all { (e :[Event]) -> Void in
            self.events = e
            self.tableView.reloadData()
        }
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :UITableViewCell
        
        if (indexPath.row % 2) == 1 {
            let e = tableView.dequeueReusableCellWithIdentifier(EventCellIdentifier) as! EventCell
            let event = events[indexPath.row / 2]
            e.categoryLabel?.text = event.side.rawValue
            e.timeLabel?.text = dateFormatter.stringFromDate(event.timestamp)
            cell = e
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(IntervalCellIdentifier) as! UITableViewCell
            cell.backgroundColor = .lightGrayColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count(events) * 2
    }
    
    func add(side: Side) {
        let e = Event(timestamp: NSDate(), side: side)
        save(e)
        tableView.beginUpdates()
        events = [e] + events
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0), NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        tableView.endUpdates()
    }
    
    @IBAction func logLeft(sender :AnyObject) {
        add(.L)
    }
    
    @IBAction func logRight(sender :AnyObject) {
        add(.R)
    }
}
