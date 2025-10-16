//
//  LikedViewModel.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 14/10/2025.
//

import Foundation
import Combine
import CoreData

final class LikedViewModel: NSObject, NSFetchedResultsControllerDelegate {
    private let storageService: SaveImageService
    private(set) var frc: NSFetchedResultsController<ImageData>!

    var onChange: (() -> Void)?

    init(storageService: SaveImageService) {
        self.storageService = storageService
        super.init()
        setupFetchedResultsController()
    }

    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<ImageData> = ImageData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ImageData.id, ascending: false)]

        frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                         managedObjectContext: storageService.context,
                                         sectionNameKeyPath: nil,
                                         cacheName: nil)
        frc.delegate = self

        try? frc.performFetch()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.onChange?()
        }
    }
    
    func fetchImages() {
        self.onChange?()
    }

    var likedImages: [ImageData] {
        frc.fetchedObjects ?? []
    }
}
