//
//  LoaderCell.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 12/04/2025.
//

import UIKit


class LoaderCell: UICollectionViewCell {
    
    static let identifier = "LoaderCell"
    
    var inidicator : UIActivityIndicatorView = {
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
        contentView.addSubview(inidicator)
        inidicator.center = contentView.center
        inidicator.startAnimating()
    }
    
}
