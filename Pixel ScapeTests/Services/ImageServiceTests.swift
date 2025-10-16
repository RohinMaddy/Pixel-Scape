//
//  ImageServiceTests.swift
//  Pixel ScapeTests
//
//  Created by Rohin Madhavan on 16/10/2025.
//

import Testing
import CoreData
@testable import Pixel_Scape

struct ImageServiceTests {

    var target: SaveImageService

       init() {
           let context = MockCoreDataStack.shared.context
           target = SaveImageService(context: context)
       }
    
    @Test("Fetch an image")
    func fetchImageTest() {
        target.saveImage(123, imageUrl: "https://example.com")
        
        let images = target.fetchSavedImage()
        
        #expect(images.count == 1)
        #expect(images.first?.id == 123)
        #expect(images.first?.imageUrl == "https://example.com")
    }
    
    @Test("Delete an image")
    func deleteImageTest() {
        target.saveImage(123, imageUrl: "https://example_one.com")
        target.saveImage(456, imageUrl: "https://example_two.com")
        
        var images = target.fetchSavedImage()
        #expect(images.count == 2)
        
        target.deleteImage(123)
        
        images = target.fetchSavedImage()
        #expect(images.count == 1)
        #expect(images.first?.id == 456)
        #expect(images.first?.imageUrl == "https://example_two.com")
    }
    
    
}
