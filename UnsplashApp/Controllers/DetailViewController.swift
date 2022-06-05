//
//  DetailViewController.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 05.06.2022.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - properties
    static let identifier = "detailCell"
   
    private let selectedPhoto: Photo
    private var models = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var twoFacedBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: SavedPhotos.shared.savedPhoto.contains(selectedPhoto) ? UIImage(systemName: "trash") : UIImage(systemName: "plus"),
            style: .plain, target: self,
            action: #selector(twoFacedbuttonTapped)
        )
        return button
    }()
    
    // MARK: - init
    init(selectedPhoto: Photo) {
        self.selectedPhoto = selectedPhoto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButtonState()
    }
}

extension DetailViewController {
    // MARK: - add button action
    @objc
    private func twoFacedbuttonTapped() {
        guard let tabBar = self.tabBarController as? TabBarViewController,
              let navVC = tabBar.viewControllers?.last as? UINavigationController,
              let favoritesVC = navVC.viewControllers.first(where: { $0.title == "Любимые" }) as? FavoritesViewController
        else { return }

        if SavedPhotos.shared.savedPhoto.contains(selectedPhoto) {
            SavedPhotos.shared.savedPhoto.remove(selectedPhoto)
            favoritesVC.collectionView.reloadData()
        } else {
            SavedPhotos.shared.savedPhoto.insert(selectedPhoto)
            favoritesVC.collectionView.reloadData()
        }
        updateButtonState()
    }
    
    private func updateButtonState() {
        if SavedPhotos.shared.savedPhoto.contains(selectedPhoto) {
            twoFacedBarButtonItem.image = UIImage(systemName: "trash")
        } else {
            twoFacedBarButtonItem.image = UIImage(systemName: "plus")
        }
    }
    
    // MARK: - setup and update UI
    private func setupUI() {
        title = "Обзор"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        navigationItem.rightBarButtonItem = twoFacedBarButtonItem
        updateUI()
        view.backgroundColor = .systemBackground
    }
    
    private func updateUI() {
        tableView.isHidden = false
        var location = "нет информации"
        var downloads = "нет информации"
        
        if let down = selectedPhoto.downloads {
            downloads = "\(down)"
        }
        if let locName = selectedPhoto.location?.name {
            location = locName
        }
        
        models.append("Автор: \(selectedPhoto.user.name)")
        models.append("Дата создания: \(selectedPhoto.created_at.toDateString(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ", ouputDateFormat: "MM-dd-yyyy HH:mm"))")
        models.append("Местоположение: \(location)")
        models.append("Кол-во скачиваний: \(downloads)")
        createTableHeader(with: selectedPhoto.urls["regular"])
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?) {
        guard let urlString = string,
              let url = URL(string: urlString)
        else { return }
        
        let headerView = UIView(
            frame:
                CGRect(
                    x: 0,
                    y: 0,
                    width: view.width,
                    height: view.width
                )
        )
        let imageView = UIImageView(
            frame:
                CGRect(
                    x: 0,
                    y: 0,
                    width: headerView.width,
                    height: headerView.height - 20
                )
        )
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFit
        imageView.sd_setImage(with: url, completed: nil)
        imageView.layer.masksToBounds = true
        
        tableView.tableHeaderView = headerView
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController.identifier, for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.selectionStyle = .none
        return cell
    }
}
