//
//  FavoritesViewController.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 04.06.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - porperties
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
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        termLabel.isHidden = SavedPhotos.shared.savedPhoto.count != 0
        return SavedPhotos.shared.savedPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesCell.identifier,
            for: indexPath
        ) as? FavoritesCell else {
            return UICollectionViewCell()
        }
        
        let photoArray = Array(SavedPhotos.shared.savedPhoto)
        let unsplashPhoto = photoArray[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let photoArray = Array(SavedPhotos.shared.savedPhoto)
        let vc = DetailViewController(selectedPhoto: photoArray[indexPath.item])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width/2 - 1 , height: collectionView.width/2 - 1)
    }
}
