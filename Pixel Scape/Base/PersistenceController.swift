//
//  PersistenceController.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 14/10/2025.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "SavedImageModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed: \(error)")
            }
        }
    }
}
