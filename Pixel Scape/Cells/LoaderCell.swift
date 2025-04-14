//
//  LoaderCell.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 12/04/2025.
//

import UIKit


class LoaderCell: UICollectionViewCell {
    
    static let identifier = "LoaderCell"
    
    var indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        contentView.addSubview(indicator)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .secondaryShade
        indicator.color = .tertiaryShade

        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        indicator.startAnimating()
    }
    
}
