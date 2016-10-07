//
//  TodayViewController.swift
//  TcehWidget
//
//  Created by Dmitriy Borovikov on 06.10.16.
//  Copyright © 2016 Borovikov. All rights reserved.
//

import UIKit
import NotificationCenter

// URL
// http://tceh.com/hello.html?q=try

// tceh://newentry

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    let entries = Entry.loadEntries(3)
    
    @IBOutlet weak var tableEntries: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableEntries.dataSource = self
        tableEntries.delegate = self
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Нужно сделать ячейку (EntryCell)
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell") as! EntryCell
        
        let entry = entries[indexPath.row]
        
        cell.categoryLabel.text = entry.category
        cell.amountLabel.text = String(format: "%.2f р.", entry.amount)
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: "tceh://newentry")!
        
        extensionContext?.openURL(url, completionHandler: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
