//
//  Filter.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 22/01/2026.
//

import Foundation

enum Filter: CaseIterable, Identifiable {
    case original
    case instant
    case chrome
    case process
    case transfer
    case fade
    case mono
    case tonal
    case noir
    case sepia
}

extension Filter {
    var id: String { displayName }

    var displayName: String {
        switch self {
        case .original: 
            return "Original"
        case .instant:
            return "Instant"
        case .chrome: 
            return "Chrome"
        case .process: 
            return "Process"
        case .transfer: 
            return "Transfer"
        case .fade: 
            return "Fade"
        case .mono: 
            return "Mono"
        case .tonal: 
            return "Tonal"
        case .noir: 
            return "Noir"
        case .sepia: 
            return "Sepia"
        }
    }

    var ciFilterName: String? {
            switch self {
            case .original:
                return nil
            case .instant:
                return "CIPhotoEffectInstant"
            case .chrome:
                return "CIPhotoEffectChrome"
            case .process:
                return "CIPhotoEffectProcess"
            case .transfer:
                return "CIPhotoEffectTransfer"
            case .fade:
                return "CIPhotoEffectFade"
            case .mono:
                return "CIPhotoEffectMono"
            case .tonal:
                return "CIPhotoEffectTonal"
            case .noir:
                return "CIPhotoEffectNoir"
            case .sepia:
                return "CISepiaTone"
            }
        }
}
