//
//  PersistanceManager.swift
//  UnsplashImageViewer
//
//  Created by Nikolas Omelianov on 8/17/19.
//  Copyright © 2019 Nikolas Omelianov. All rights reserved.
//

import Foundation
import CoreData

final class PersistanceManager {
    
    private init() {}
    static let shared = PersistanceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UnsplashImageViewer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("saved successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T] {
        var result = [T]()
        let entityName = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do{
            let fetchedObjects = try context.fetch(fetchRequest) as? [T]
            result = fetchedObjects!
        } catch {
            print(error)
        }
        
        return result
    }
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        save()
    }
}
