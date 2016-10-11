//
//  CategoriesViewController.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 04.09.16.
//  Copyright © 2016 Pronin. All rights reserved.
//

import UIKit
import CloudKit

protocol CategoriesViewControllerDelegate {
    func categorySelected(category: String)
    //orthodox naming
    //func categoiesViewController(controller: CategoriesViewController, didSelectCategory category: String)
}

class CategoriesViewController: UITableViewController {
    
    var categories = [String]()

    var delegate: CategoriesViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        Category.loadCategories { categories in
            
            if categories.count > 0 {
                self.categories = categories.map({ $0.name })
                
                //обновляем таблицу через Main-thread
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                })
            }
        }

    }

    @IBAction func tapCancel(sender: AnyObject) {

        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

    }

    @IBAction func tapAdd(sender: AnyObject) {
    
        let alert = UIAlertController(title: "New category", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ textField in
            textField.placeholder = "Category name..."
        })
   
        let okAction = UIAlertAction(title: "Ok", style: .Default) {_ in
            if let category = alert.textFields?.first?.text {
                self.categories.append(category)
                
                //self.tableView.reloadData()
                Category.saveCategory(category)
                
                
                let indexPath = NSIndexPath(forRow: self.categories.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
        
        let category = categories[indexPath.row]
        cell.labelCategory.text = category
        
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        // localisation!!!
        return categories[indexPath.row] != "Etc"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            Category.deleteCategory(categories[indexPath.row]) { }
                
                self.categories.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
}
