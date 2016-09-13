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
    @NSManaged var createdAt: NSDate        // Дата траты
    @NSManaged var amount: Double      // Сумма траты
    @NSManaged var venue: String       // Местро траты
    @NSManaged var category: String    // Категория траты
    
    // Костыль
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(amount: Double, venue: String, category: String) {
        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: CoreDataHelper.instance.context)!
        super.init(entity: entity, insertIntoManagedObjectContext: CoreDataHelper.instance.context)
        
        self.createdAt = NSDate()
        self.amount = amount
        self.venue = venue
        self.category = category
    }
    
    
    class func loadEntries() -> [Entry] {
        let request = NSFetchRequest(entityName: "Entry")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let results = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return results as! [Entry]
        } catch { }
        return []
    }
}
