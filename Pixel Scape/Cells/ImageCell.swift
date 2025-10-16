//
//  ImageCell.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = ""
        button.setImage(UIImage(systemName: "heart.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var heightConstraint: NSLayoutConstraint!
    private var buttonHeightConstraint: NSLayoutConstraint!
    private var buttonWidthConstraint: NSLayoutConstraint!
    
    var onSaveTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func configure(with urlString: String, isLiked: Bool = false) {
        loadImage(from: urlString)
        setButtonImage(isLiked: isLiked)
    }
    
    func hideButton() {
        button.isHidden = true
    }
    
    func setButtonImage(isLiked: Bool) {
        let imageName = isLiked ? "heart.circle" : "heart.circle.fill"
        
        button.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(handleLikedButtonTapped) , for: .touchUpInside)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: CGFloat.random(in: imageView.frame.width...400))
        heightConstraint.isActive = true
        buttonHeightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
        buttonHeightConstraint.isActive = true
        buttonWidthConstraint = button.heightAnchor.constraint(equalToConstant: 50)
        buttonWidthConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }

    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        imageView.backgroundColor = .backgroundColorSecondary
        
        // Fetch image asynchronously
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }.resume()
    }
    
    @objc
    private func handleLikedButtonTapped() {
        onSaveTapped?()
    }
}

