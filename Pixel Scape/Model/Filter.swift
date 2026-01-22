//
//  Filter.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 22/01/2026.
//

import Foundation

enum Filter: CaseIterable, Identifiable {
    case original
    case sepia
    case mono
    case noir
}

extension Filter {
    var id: String { displayName }

    var displayName: String {
        switch self {
        case .original: return "Original"
        case .sepia: return "Sepia"
        case .mono: return "Mono"
        case .noir: return "Noir"
        }
    }

    var ciFilterName: String? {
        switch self {
        case .original: return nil
        case .sepia: return "CISepiaTone"
        case .mono: return "CIPhotoEffectMono"
        case .noir: return "CIPhotoEffectNoir"
        }
    }
}
