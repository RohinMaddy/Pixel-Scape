//
//  HomeViewController.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private let viewModel = AppContainer.shared.homeViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let layout = PixelFlowLayout()
    private let refreshControl = UIRefreshControl()
    private var page = 1
    private var cachedHeights: [Int: CGFloat] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        setupImageCollectionView()
        searchView.layer.cornerRadius = 10
        applyBindings(in: &subscriptions)
        setupTextField()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        imageCollectionView.alwaysBounceVertical = true
        imageCollectionView.refreshControl = refreshControl
        viewModel.fetchPixel()
        viewModel.getSavedImages()
    }
    
    func setupTextField() {
        searchTextField.placeholder = "Looking for anything specific?"
        if let placeholder = searchTextField.placeholder {
            
            searchTextField.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.textShade])
        }
    }
    
    func applyBindings(in subscriptions: inout Set<AnyCancellable>) {
        viewModel.$imageData
            .receive(on: DispatchQueue.main)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                if self.isViewLoaded && self.view.window != nil {
                    self.imageCollectionView.reloadData()
                }
            }
            .store(in: &subscriptions)
        viewModel.$searchText
            .assign(to: \.text, on: searchTextField)
            .store(in: &subscriptions)
    }
    
    private func setupImageCollectionView() {
        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        imageCollectionView.register(LoaderCell.self, forCellWithReuseIdentifier: LoaderCell.identifier)
        imageCollectionView.layer.cornerRadius = 10
        
        updateCollectionView()
    }
    
    @MainActor
    func updateCollectionView() {
        viewModel.onItemsAppended = { [weak self] indexPaths in
            guard let self else { return }
            if self.imageCollectionView.hasUncommittedUpdates {
                self.imageCollectionView.reloadData()
            } else {
                self.imageCollectionView.performBatchUpdates({
                    self.imageCollectionView.insertItems(at: indexPaths)
                })
            }
        }
        
        viewModel.onLiked = {[weak self] (indexPath, isLiked) in
            guard let self = self else { return }
            self.imageCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        viewModel.fetchPixel()
        refreshControl.endRefreshing()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        viewModel.fetchPixel(query: searchTextField?.text)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != viewModel.imageData?.photos.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            
            if let photo = viewModel.imageData?.photos[indexPath.row] {
                let isLiked = viewModel.savedImages?.contains { $0.id == photo.id }
                
                cell.configure(with: photo.src.portrait, isLiked: isLiked ?? false)
                
                cell.onSaveTapped = { [weak self] in
                    guard let self = self else { return }
                    
                    self.viewModel.toggleSave(
                        imageId: Int64(photo.id),
                        ImageUrl: photo.src.portrait,
                        isLiked: isLiked ?? false,
                        indexPath: indexPath
                    )
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoaderCell.identifier, for: indexPath) as! LoaderCell
            cell.indicator.startAnimating()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel.imageData?.photos.count ?? 0 > 0) ? ((viewModel.imageData?.photos.count ?? 0) + 1) : 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cachedHeights[indexPath.row] == nil {
            cachedHeights[indexPath.row] = CGFloat.random(in: 250...350)
        }
        return layout.updateLayout(for: cachedHeights[indexPath.row]!)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let editVC = storyboard?.instantiateViewController(identifier: "EditViewController") as? EditViewController {
            editVC.imageUrl = viewModel.imageData?.photos[indexPath.row].src.portrait ?? ""
            show(editVC, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == viewModel.imageData?.photos.count ) && !viewModel.isFetching {
            let page = (Int(viewModel.imageData?.photos.count ?? 0) / 15) + 1
            viewModel.loadMore(page: page, query: searchTextField?.text)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
