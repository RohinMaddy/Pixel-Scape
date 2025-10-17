//
//  MockImageStorageService.swift
//  Pixel ScapeTests
//
//  Created by Rohin Madhavan on 17/10/2025.
//

import Foundation
import CoreData
import Combine
@testable import Pixel_Scape

final class MockImageStorageService: ImageStorageService {
    
    var changesPublisher = PassthroughSubject<Void, Never>()
    let context = MockCoreDataStack.shared.context
    
    func saveImage(_ id: Int64, imageUrl: String) {
        let imageData = ImageData(context: context)
        imageData.id = id
        imageData.imageUrl = imageUrl
        try? context.save()
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
        
        try? context.save()
    }
    
}
