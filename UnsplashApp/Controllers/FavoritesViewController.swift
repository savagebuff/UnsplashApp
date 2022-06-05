//
//  FavoritesViewController.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 04.06.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - porperties
    var photos = [Photo]()
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonTapped))
        return button
    }()
    
    let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.minimumLineSpacing = 1
        viewLayout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let termLabel: UILabel = {
        let label = UILabel()
        let text = """
                   Вы еще не добавили
                   ни одного фото
                   """
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

}

extension FavoritesViewController {
    // MARK: - trash button action
    @objc
    private func trashBarButtonTapped() {
        print(#function)
    }
    
    // MARK: - setup UI
    private func setupUI() {
        collectionView.register(FavoritesCell.self , forCellWithReuseIdentifier: FavoritesCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        collectionView.backgroundColor = .systemBackground
        
        collectionView.addSubview(termLabel)
        NSLayoutConstraint.activate([
            termLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            termLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
        
        navigationItem.rightBarButtonItem = trashBarButtonItem
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sorted = photos.filterDuplicates { $0.user.name == $1.user.name && $0.created_at == $1.created_at }
        photos = sorted
        termLabel.isHidden = photos.count != 0
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesCell.identifier,
            for: indexPath
        ) as? FavoritesCell else {
            return UICollectionViewCell()
        }
        
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width/2 - 1 , height: collectionView.width/2 - 1)
    }
}
