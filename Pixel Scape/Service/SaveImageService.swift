//
//  SaveImageService.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 14/10/2025.
//

import Foundation
import CoreData

protocol ImageStorageService {
    func saveImage(_ id: Int64, imageUrl: String)
    func fetchSavedImage() -> [ImageData]
    func deleteImage(_ id: Int64)
}

final class SaveImageService: ImageStorageService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func saveImage(_ id: Int64, imageUrl: String) {
        let entity = ImageData(context: context)
        entity.id = id
        entity.imageUrl = imageUrl
        
        saveContext()
    }

    func fetchSavedImage() -> [ImageData] {
        let request = ImageData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ImageData.id, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    func deleteImage(_ id: Int64) {
        if let result = try? context.fetch(ImageData.fetchRequest()) {
            for object in result {
                if object.id == id {
                    context.delete(object)
                }
            }
        }

        do {
            try context.save()
        } catch {
            print("Error deleting")
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
