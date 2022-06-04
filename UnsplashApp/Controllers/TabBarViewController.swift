//
//  TabBarViewController.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 04.06.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    // MARK: - properties
    
    private let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    private let favoriteVC = FavoriteViewController()
    
    
    
    // MARK: - livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        setup()
    }
}

extension TabBarViewController {
    private func setup() {
        guard let photosImage = UIImage(systemName: "photo.on.rectangle.angled"),
              let heartImage = UIImage(systemName: "heart.fill")
        else { return }
        
        setViewControllers([
            createNavigationControllerFrom(
                viewController: photosVC,
                title: "Галерея",
                image: photosImage
            ),
            createNavigationControllerFrom(
                viewController: favoriteVC,
                title: "Любимые",
                image: heartImage
            )
        ],  animated: false)
    }
    
    private func createNavigationControllerFrom(viewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        viewController.title = title
        viewController.navigationItem.largeTitleDisplayMode = .always
        
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.navigationBar.tintColor = .label
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.tabBarItem = UITabBarItem(title: title, image: image, tag: 1)
        return navigationVC
    }
}
