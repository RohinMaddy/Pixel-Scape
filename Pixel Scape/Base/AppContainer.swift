//
//  AppContainer.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 14/10/2025.
//

import Foundation
import UIKit

final class AppContainer {
    static var shared =  AppContainer()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var apiService: ApiService = PixelApiService()
    lazy var imageService = SaveImageService(context: context)
    
    lazy var homeViewModel = HomeViewModel(apiService: apiService, imageService: imageService)
    lazy var likedViewModel = LikedViewModel(storageService: imageService)
}
