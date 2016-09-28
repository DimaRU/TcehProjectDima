//
//  CoreDataHelper.swift
//  TcehProject
//
//  Created by Dmitriy Borovikov on 12.09.16.
//  Copyright © 2016 Pronin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    let model: NSManagedObjectModel
    let coordinator: NSPersistentStoreCoordinator
    let context: NSManagedObjectContext
    
    static let instance = CoreDataHelper()      // One instance per app only
    
    private override init() {
        let fileManager = NSFileManager.defaultManager()
        
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        self.model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let storeURL = docsURL.URLByAppendingPathComponent("store.sqlite")

        let options = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSPersistentStoreUbiquitousContentNameKey: "123"]
        
        do {
            try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {
            print("Can't open pesistent storage")
        }
        
        self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.coordinator
    }
}
