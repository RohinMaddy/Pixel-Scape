//
//  FilterCell.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 22/01/2026.
//

import Foundation

import UIKit

class FilterCell: UICollectionViewCell {
    static let identifier = "FilterCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private var heightConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 60.0)
        heightConstraint.isActive = true
        widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 50.0)
        widthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func loadImage(image: UIImage) {
        imageView.image = image
    }
}
