//
//  AppContainer.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 14/10/2025.
//

import Foundation

final class AppContainer {
    static var shared =  AppContainer()
    
    lazy var apiService: ApiService = PixelApiService()
    lazy var imageService = SaveImageService()
    lazy var filterService: FilterServiceProtocol = FilterService()
    
    lazy var homeViewModel = HomeViewModel(apiService: apiService, imageService: imageService)
    lazy var likedViewModel = LikedViewModel(storageService: imageService)
    lazy var editViewModel = EditViewModel(filterService: filterService)
}
