//
//  PhotosCollectionViewController.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 04.06.2022.
//

import UIKit

class PhotosCollectionViewController: UIViewController {
    // MARK: - properties
    private var photos = [Photo]()
    
    private let itemsPerRow: CGFloat = 2.0
    private let sectionInserts = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: nil)
        vc.searchBar.placeholder = "Поиск"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        setupRandomPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension PhotosCollectionViewController {
    // MARK: - buttons action
    @objc
    private func addBarButtonTapped() {
        print(#function)
    }
    // MARK: - setup UI
    private func setupRandomPhotos() {
        guard checkRechability() else { return }
        APICaller.shared.fetchRandomPhotos { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                case .success(let result):
                    self?.photos = result
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupUI() {
        collectionView.register(PhotoCell.self , forCellWithReuseIdentifier: PhotoCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    // MARK: - check rechability network
    private func checkRechability() -> Bool {
        guard Reachability.isConnectedToNetwork() else {
            let alert = UIAlertController(title: "Ошибка", message: "Нет соединения", preferredStyle: .alert)
            let action = UIAlertAction(title: "Перезагрузить", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

// MARK: - UISearchBarDelegate
extension PhotosCollectionViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        return
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard checkRechability(),
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else { return }
        
        APICaller.shared.search(with: query) { [weak self] searchResults in
            DispatchQueue.main.async {
                switch searchResults {
                case .success(let searchResults):
                    self?.photos = searchResults.results
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PhotosCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifier,
            for: indexPath
        ) as? PhotoCell else {
            return UICollectionViewCell()
        }
        
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = DetailViewController(selectedPhoto: photos[indexPath.item])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

