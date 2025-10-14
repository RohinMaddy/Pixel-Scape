//
//  SaveImageService.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 14/10/2025.
//

import Foundation
import CoreData

protocol ImageStorageService {
    func saveImageURL(_ image: ImageData)
    func fetchSavedImageURLs() -> [ImageData]
    func deleteImageURL(_ url: Int64)
}

final class SaveImageService: ImageStorageService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func saveImageURL(_ image: ImageData) {
        let entity = ImageData(context: context)
        entity.id = image.id
        entity.imageUrl = image.imageUrl
        
        saveContext()
    }

    func fetchSavedImageURLs() -> [ImageData] {
        let request = ImageData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ImageData.id, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    func deleteImageURL(_ id: Int64) {
        let request = ImageData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(request)
            results.forEach(context.delete)
            saveContext()
        } catch {
            print("Delete error: \(error)")
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}
