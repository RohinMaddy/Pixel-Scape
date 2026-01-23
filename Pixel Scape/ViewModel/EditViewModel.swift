//
//  EditViewModel.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 22/01/2026.
//

import Foundation
import UIKit


class EditViewModel {
    
    @Published private(set) var filterImages: [FilteredImage] = []
    @Published private(set) var selectedImage: UIImage?
    
    private let filterService: FilterServiceProtocol
    private var originalImage: UIImage?
    
    init(filterService: FilterServiceProtocol) {
        self.filterService = filterService
    }
    
    func setImage(image: UIImage) {
        originalImage = image
    }
    
    func loadThumbnails() {
        Task {
            guard let originalImage else { return }
            do {
                let result = try await filterService.getThumbnails(from: originalImage)
                self.filterImages = result
            } catch { print(error) }
        }
    }
    
    func applyFilter(_ filter: Filter) {
        guard let originalImage, let ciImage = CIImage(image: originalImage) else { return }
        let output = filterService.apply(
            filter: filter,
            to: ciImage
        )
        self.selectedImage = output
    }
}
