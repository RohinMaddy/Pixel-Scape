//
//  FilterService.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 22/01/2026.
//

import Foundation
import CoreImage
import UIKit

struct FilteredImage {
    let filter: Filter
    let image: UIImage
}

protocol FilterServiceProtocol {
    func getThumbnails(from image: UIImage) async -> [FilteredImage]
}


final class FilterService: FilterServiceProtocol {
    private let context = CIContext()
    
    func getThumbnails(from image: UIImage) async -> [FilteredImage] {
        
        let resized = image.aspectFittedToHeight(80)
        let ciImage = CIImage(image: resized)!
        
        return await withTaskGroup(of: FilteredImage?.self) { group in
            for filter in Filter.allCases {
                group.addTask {
                    guard let output = self.apply(filter: filter, to: ciImage)
                    else { return nil }
                    
                    return FilteredImage(filter: filter, image: output)
                }
            }
            
            var results: [FilteredImage] = []
            
            for await item in group {
                if let item {
                    results.append(item)
                }
            }
            
            return results
        }
    }
}

private extension FilterService {

    func apply(filter: Filter, to image: CIImage) -> UIImage? {

        let outputImage: CIImage

        if let filterName = filter.ciFilterName,
           let ciFilter = CIFilter(name: filterName) {

            ciFilter.setValue(image, forKey: kCIInputImageKey)
            outputImage = ciFilter.outputImage ?? image
        } else {
            outputImage = image
        }

        guard let cgImage = context.createCGImage(
            outputImage,
            from: outputImage.extent
        ) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
