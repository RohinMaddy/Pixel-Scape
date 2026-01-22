//
//  MockCoreDataStack.swift
//  Pixel ScapeTests
//
//  Created by Rohin Madhavan on 16/10/2025.
//

import Foundation
import CoreData

final class MockCoreDataStack {
    static let shared = MockCoreDataStack()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedImageModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition( description.type == NSInMemoryStoreType )
                                        
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
}
