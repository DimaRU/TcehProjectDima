//
//  Venue.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 17.09.16.
//  Copyright © 2016 Borovikov. All rights reserved.
//

import UIKit
import CoreData

@objc(Venue)
class Venue: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var distance: Int64
    @NSManaged var categoryImageURL: String
    
    convenience init(name: String, latitude: Double, longitude: Double, distance: Int64, categoryImageURL: String) {
        let entity = NSEntityDescription.entityForName("Venue",
                                                       inManagedObjectContext: CoreDataHelper.instance.context)!
       
        self.init(entity:entity, insertIntoManagedObjectContext: nil)
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.categoryImageURL = categoryImageURL
    }

    class func loadVenues() -> [Venue] {
        let request = NSFetchRequest(entityName: "Venue")
        
        do {
            let results = try CoreDataHelper.instance.context.executeFetchRequest(request)
            return results as! [Venue]
        } catch {
            print("Venues load error")
        }
        
        
        return []
    }
    
}
