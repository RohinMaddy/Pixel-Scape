//
//  MockPixelApiService.swift
//  Pixel ScapeTests
//
//  Created by Rohin Madhavan on 17/10/2025.
//

import Foundation

@testable import Pixel_Scape

final class MockPixelApiService: ApiService {
    
    var shouldThrowError = false
    var mockResponse: Pixel = Pixel(photos: [])
    
    func getCuratedPhotos(page: Int) async throws -> Pixel {
        if shouldThrowError { throw PixelError.invalidStatusCode }
        return mockResponse
    }
    
    func getSearchedWallpapers(query: String, page: Int) async throws -> Pixel {
        if shouldThrowError { throw PixelError.invalidStatusCode }
        return mockResponse
    }
    
    
}

