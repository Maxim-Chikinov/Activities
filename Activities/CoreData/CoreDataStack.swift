//
//  CoreDataStack.swift
//  Activities
//
//  Created by Chikinov Maxim on 19.03.2024.
//

import CoreData

class CoreDataStack {
    
    static var shared = CoreDataStack()
    
    private init() {}
    
    var managedObjectContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.managedObjectContext
        return context
    }
    
    // MARK: - Core Data stack
    
    private let storeName: String = "ActivitesDataModel"
    
    var storeURL: URL {
        let storePaths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let storePath = storePaths[0] as NSString
        let fileManager = FileManager.default
        
        do {
            try fileManager.createDirectory(
                atPath: storePath as String,
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            print("Error creating storePath \(storePath): \(error)")
        }
        
        let sqliteFilePath = storePath.appendingPathComponent(storeName + ".sqlite")
        
        return URL(fileURLWithPath: sqliteFilePath)
    }
    
    lazy var storeDescription: NSPersistentStoreDescription = {
        let description = NSPersistentStoreDescription(url: self.storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = false
        return description
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasks")
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        self.managedObjectContext.performAndWait {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                    print("Main context saved")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveWorkingContext(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Working context saved")
            saveContext()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    func delete(item: NSManagedObject) {
        managedObjectContext.delete(item)
        saveContext()
    }
}
