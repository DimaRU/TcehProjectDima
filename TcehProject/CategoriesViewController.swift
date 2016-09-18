//
//  CategoriesViewController.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 04.09.16.
//  Copyright © 2016 Pronin. All rights reserved.
//

import UIKit

protocol CategoriesViewControllerDelegate {
    func categorySelected(category: String)
    //orthodox naming
    //func categoiesViewController(controller: CategoriesViewController, didSelectCategory category: String)
}

class CategoriesViewController: UITableViewController {

    var categories = ["Food", "Entertainment", "Transport", "Flat", "Gas", "Etc"]

    var delegate: CategoriesViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func tapCancel(sender: AnyObject) {

        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        
        //cell.labelCategory.text = "Row #\(indexPath.row)"
        let category = categories[indexPath.row]
        cell.labelCategory.text = category
        
        //cell.selectionStyle = UITableView
        //cell.separatorInset.left = 0
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let category = categories[indexPath.row]
        print("User selected  \(category)")
        
        //Скажем делегату, что событие произошло
        delegate?.categorySelected(category)
        
        // убрать выделение с ячейки
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
