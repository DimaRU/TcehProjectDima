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
    let concurrent: NSManagedObjectContext
    
    static let instance = CoreDataHelper()      // One instance per app only
    
    private override init() {
        let fileManager = NSFileManager.defaultManager()
        
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        self.model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        //let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        let docsURL = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.me.Borovikov.TcehProject")!
        
        let storeURL = docsURL.URLByAppendingPathComponent("store.sqlite")

        let options = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true,
            //NSPersistentStoreUbiquitousContentNameKey: "123"
        ]
        
        do {
            try self.coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {
            print("Can't open pesistent storage")
        }
        
        self.context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.coordinator
        
        self.concurrent = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        self.concurrent.persistentStoreCoordinator = self.coordinator
        
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.corncurrentDidSave(_:)),
                                                         name: NSManagedObjectContextDidSaveNotification,
                                                         object: concurrent)
        
        
    }
    
    func corncurrentDidSave(notification: NSNotification) {
        
        context.performBlock({
            
            if let updated = notification.userInfo?[NSUpdatedObjectsKey] as? [NSManagedObject] {
                for obj in updated {
                    // обновить состояние обекта до актуального
                    self.context.objectWithID(obj.objectID).willAccessValueForKey(nil)
                }
            }
            
            self.context.mergeChangesFromContextDidSaveNotification(notification)
            
        })
    }
    
    
    func saveMain() {
        do {
            try context.save()
        } catch let error {
            print("main save error \(error)")
        }
    }
    
    func saveConcurrent() {
        do {
            try concurrent.save()
        } catch let error {
            print("concurrent save error \(error)")
        }
    }
    
    
}
