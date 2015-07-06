//
//  ViewController.swift
//  WhichSide
//
//  Created by Fabian Canas on 7/5/15.
//  Copyright (c) 2015 Fabián Cañas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var tableView :UITableView!
    @IBOutlet var headerView :UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        tableView.registerNib(UINib(nibName: "RowCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tableView.registerNib(UINib(nibName: "IntervalCell", bundle: nil), forCellReuseIdentifier: "IntervalCell")
        
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell :UITableViewCell
        
        if (indexPath.row % 2) == 1 {
            cell = tableView.dequeueReusableCellWithIdentifier("EventCell") as! UITableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("IntervalCell") as! UITableViewCell
            cell.backgroundColor = .lightGrayColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}
