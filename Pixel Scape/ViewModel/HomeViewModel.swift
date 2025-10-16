//
//  HomeViewModel.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import Foundation
import Combine
import UIKit

class HomeViewModel {
    
    @Published private(set) var searchText: String?
    @Published private(set) var imageData: Pixel?
    
    private let apiService: ApiService
    private let imageService: ImageStorageService
    var isFetching = false
    var onItemsAppended: (([IndexPath]) -> Void)?
    var onLiked: ((IndexPath, Bool) -> Void)?
    var savedImages: [ImageData]?
    
    private var cancellables = Set<AnyCancellable>()

    init(apiService: ApiService, imageService: ImageStorageService) {
        self.apiService = apiService
        self.imageService = imageService

        imageService.changesPublisher
            .sink { [weak self] in
                self?.refreshLikes()
            }
            .store(in: &cancellables)
    }

    private func refreshLikes() {
        print("HomeViewModel: detected Core Data change")
        savedImages = imageService.fetchSavedImage()
    }
    
    func fetchPixel(page: Int = 1, query: String? = nil) {
        Task{
            do {
                imageData = Pixel(photos: [])
                if let query, query != "" {
                    imageData = try await apiService.getSearchedWallpapers(query: query, page: page)
                } else {
                    imageData = try await apiService.getCuratedPhotos(page: page)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func loadMore(page: Int = 1, query: String? = nil) {
        guard !isFetching else { return }
        isFetching = true
        var data = Pixel(photos: [])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            Task{
                do {
                    if let query, query != "" {
                        data = try await self.apiService.getSearchedWallpapers(query: query, page: page)
                    } else {
                        data = try await self.apiService.getCuratedPhotos(page: page)
                    }
                    let start = self.imageData?.photos.count
                    self.imageData?.photos.append(contentsOf: data.photos)
                    let end = self.imageData?.photos.count
                    let indexPaths = ((start ?? 0)..<(end ?? 0)).map { IndexPath(item: $0, section: 0) }
                    self.onItemsAppended?(indexPaths)
                } catch {
                    print(error)
                }
                self.isFetching = false
            }
        }
    }
    
    func getSavedImages() {
        savedImages = imageService.fetchSavedImage()
    }
    
    func toggleSave(imageId: Int64, ImageUrl:  String, isLiked: Bool, indexPath: IndexPath) {
        if !isLiked {
            imageService.saveImage(imageId, imageUrl: ImageUrl)
        } else {
            imageService.deleteImage(imageId)
        }
        
        onLiked?(indexPath, isLiked)
    }
}
