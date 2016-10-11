//
//  Category.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 10.10.16.
//  Copyright © 2016 Borovikov. All rights reserved.
//

import UIKit
import CloudKit

class Category: NSObject {

    
    let name: String
    let imageURL: String?
    
    init(name: String, imageURL: String? = nil) {
        self.name = name
        self.imageURL = imageURL
    }
    
    class func loadCategories(completion: ([Category] -> Void)) {
        
        let container = CKContainer(identifier: "iCloud.com.tceh.app")
        let database = container.publicCloudDatabase
        
        let query = CKQuery(recordType: "Category", predicate: NSPredicate(value: true))
        
        database.performQuery(query, inZoneWithID: nil) { records, error in
            
            if let error = error {
                print("Loading error: \(error)")
            }
            
            guard let records = records else { return }
            
            var categories = [Category]()
            
            for record in records {
                let name = record["name"] as! String
                let imageURL = record["imageURL"] as? String
                
                
                let category = Category(name: name, imageURL: imageURL)
                categories.append(category)
            }
            
            completion(categories)
            
        }
        
    }
    
    class func saveCategory(name: String) {
        
        let container = CKContainer(identifier: "iCloud.com.tceh.app")
        let database = container.publicCloudDatabase
        
        let record = CKRecord(recordType: "Category")
        record["name"] = name
        
        database.saveRecord(record) { record, error in
            if let error = error {
                print("Loading error: \(error)")
            }
            
        }
        
    }
    
    
    class func deleteCategory(name: String, completion: (() -> Void)) {
        
        let container = CKContainer(identifier: "iCloud.com.tceh.app")
        let database = container.publicCloudDatabase
        
        let query = CKQuery(recordType: "Category",
                            predicate: NSPredicate(format: "name = %@", name))
        
        database.performQuery(query, inZoneWithID: nil) { records, error in
            if let error = error {
                print("Loading error: \(error)")
            }
            
            guard let records = records else { return }
            guard records.count > 0 else { print("No records found: \(name)") ; return }
            
            let record = records[0]
            print(record)
            
            database.deleteRecordWithID(record.recordID) { recordID, error in
                if let error = error {
                    print("Delete error: \(error)")
                } else {
                    completion()
                }
            }
            
        }
    }
    
        
}
