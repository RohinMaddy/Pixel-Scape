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
    lazy var homeViewModel = HomeViewModel(apiService: apiService)
    
    lazy var flowLayout = PixelFlowLayout()
}
