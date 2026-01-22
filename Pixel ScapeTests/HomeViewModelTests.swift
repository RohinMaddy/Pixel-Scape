//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by Rohin Madhavan on 16/10/2025.
//

import Testing

@testable import Pixel_Scape

struct HomeViewModelTests {
    
    var apiService = MockPixelApiService()
    var imageService = MockImageStorageService()
    
    var target: HomeViewModel
    
    init() async throws {
        target = .init(apiService: apiService, imageService: imageService)
    }
    
    @Test
    func fetchSavedImagesTest() {
        imageService.saveImage(123, imageUrl: "https://example.com")
        
        target.getSavedImages()
        
        #expect(target.savedImages?.count == 1)
        #expect(target.savedImages?.first?.id == 123)
        #expect(target.savedImages?.first?.imageUrl == "https://example.com")
    }
    

}
