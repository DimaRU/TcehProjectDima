//
//  Entry.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 07.09.16.
//  Copyright © 2016 Pronin. All rights reserved.
//

import UIKit
import CoreData

@objc(Entry)
class Entry: NSManagedObject {
    @NSManaged var createdAt: NSDate   // Дата траты
    @NSManaged var amount: Double      // Сумма траты
    @NSManaged var venue: Venue       // Местро траты
    @NSManaged var category: String    // Категория траты
    
    convenience init(amount: Double, venue: Venue, category: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: CoreDataHelper.instance.context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.createdAt = NSDate()
        self.amount = amount
        self.venue = venue
        self.category = category
    }
    
    class func loadEntries(limit: Int? = nil) -> [Entry] {
        let request = NSFetchRequest(entityName: "Entry")
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            let results = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return results as! [Entry]
        } catch { }

        return []
    }
}
