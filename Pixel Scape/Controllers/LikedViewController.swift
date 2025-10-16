//
//  LikedViewController.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 16/04/2025.
//

import UIKit
import Combine

class LikedViewController: UIViewController {

    @IBOutlet weak var likedImageCollectionView: UICollectionView!
    
    private let viewModel = AppContainer.shared.likedViewModel
    private let flowLayout = PixelFlowLayout()
    private let refreshControl = UIRefreshControl()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLikedCollectionView()
        applyBindings(in: &subscriptions)
        likedImageCollectionView.alwaysBounceVertical = true
        likedImageCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
    }
    
    func applyBindings(in subscriptions: inout Set<AnyCancellable>) {
        viewModel.onChange = { [weak self] in
                    guard let self = self,
                          self.isViewLoaded,
                          self.view.window != nil else { return }
                    self.likedImageCollectionView.reloadData()
                }
    }
    
    private func setupLikedCollectionView() {
        likedImageCollectionView.delegate = self
        likedImageCollectionView.dataSource = self
        likedImageCollectionView.collectionViewLayout = flowLayout
        likedImageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        likedImageCollectionView.register(LoaderCell.self, forCellWithReuseIdentifier: LoaderCell.identifier)
        likedImageCollectionView.layer.cornerRadius = 10
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        viewModel.fetchImages()
        refreshControl.endRefreshing()
    }

}

extension LikedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.likedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != viewModel.likedImages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            if let imageUrl = viewModel.likedImages[indexPath.row].imageUrl {
                cell.hideButton()
                cell.configure(with: imageUrl)
            }
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoaderCell.identifier, for: indexPath) as! LoaderCell
            cell.indicator.startAnimating()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return flowLayout.updateLayout(for: CGFloat.random(in: 250...350))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let editVC = storyboard?.instantiateViewController(identifier: "EditViewController") as? EditViewController {
            editVC.imageUrl = viewModel.likedImages[indexPath.row].imageUrl ?? ""
            show(editVC, sender: self)
        }
    }
    
}
