//
//  ViewController.swift
//  WhichSide
//
//  Created by Fabian Canas on 7/5/15.
//  Copyright (c) 2015 Fabián Cañas. All rights reserved.
//

import UIKit

let IntervalCellIdentifier = "IntervalCell"

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView :UITableView!
    @IBOutlet var headerView :UIView!
    
    lazy var dateFormatter :NSDateFormatter = {
        let f = NSDateFormatter()
        f.timeStyle = NSDateFormatterStyle.ShortStyle
        return f
        }()
    
    lazy var timeFormatter :NSDateComponentsFormatter = {
        let f = NSDateComponentsFormatter()
        f.unitsStyle = NSDateComponentsFormatterUnitsStyle.Positional
        f.allowedUnits = .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond
        f.zeroFormattingBehavior = .Pad
        return f
        }()
    
    var events = Array<Event>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        tableView.registerNib(UINib(nibName: EventCellIdentifier, bundle: nil), forCellReuseIdentifier: EventCellIdentifier)
        tableView.registerNib(UINib(nibName: IntervalCellIdentifier, bundle: nil), forCellReuseIdentifier: IntervalCellIdentifier)
        
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Query<Event>().descending("timestamp").findInBackground { e in
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
            let i = tableView.dequeueReusableCellWithIdentifier(IntervalCellIdentifier) as! IntervalCell
            cell = i
            
            if indexPath.row == 0 {
                i.intervalLabel?.text = "hi"
            } else {
                let nextEvent = events[(indexPath.row / 2)-1]
                let priorEvent = events[(indexPath.row / 2)]
                let interval = nextEvent.timestamp.timeIntervalSinceDate(priorEvent.timestamp)
                i.intervalLabel?.text = timeFormatter.stringFromTimeInterval(interval)
            }
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
