//
//  SaveImageService.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 14/10/2025.
//

import Foundation
import CoreData
import Combine
import UIKit

protocol ImageStorageService {
    var changesPublisher: PassthroughSubject<Void, Never> { get }
    func saveImage(_ id: Int64, imageUrl: String)
    func fetchSavedImage() -> [ImageData]
    func deleteImage(_ id: Int64)
}

final class SaveImageService: ImageStorageService {
    let context: NSManagedObjectContext
    let changesPublisher = PassthroughSubject<Void, Never>()

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    func saveImage(_ id: Int64, imageUrl: String) {
        let entity = ImageData(context: context)
        entity.id = id
        entity.imageUrl = imageUrl
        saveContext()
        changesPublisher.send(())
    }

    func fetchSavedImage() -> [ImageData] {
        let request: NSFetchRequest<ImageData> = ImageData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ImageData.id, ascending: false)]
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }

    func deleteImage(_ id: Int64) {
        if let result = try? context.fetch(ImageData.fetchRequest()) {
            for object in result where object.id == id {
                context.delete(object)
            }
        }
        saveContext()
        changesPublisher.send(())
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
    }
}

