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
   
    private let selectPhoto: Photo
    private var models = [String]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        return button
    }()
    
    // MARK: - init
    init(selectPhoto: Photo) {
        self.selectPhoto = selectPhoto
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
}

extension DetailViewController {
    // MARK: - add button action
    @objc
    private func addButtonTapped() {
        print(#function)
        
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
        navigationItem.rightBarButtonItem = addBarButtonItem
        updateUI()
        view.backgroundColor = .systemBackground
    }
    
    private func updateUI() {
        tableView.isHidden = false
        var location = "нет информации"
        var downloads = "нет инфомации"
        
        if let down = selectPhoto.downloads {
            downloads = "\(down)"
        }
        if let locName = selectPhoto.location?.name {
            location = locName
        }
        
        models.append("Автор: \(selectPhoto.user.name)")
        models.append("Дата создания: \(selectPhoto.created_at.toDateString(inputDateFormat: "yyyy-MM-dd'T'HH:mm:ssZ", ouputDateFormat: "MM-dd-yyyy HH:mm"))")
        models.append("Местоположение: \(location)")
        models.append("Кол-во скачиваний: \(downloads)")
        createTableHeader(with: selectPhoto.urls["regular"])
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
