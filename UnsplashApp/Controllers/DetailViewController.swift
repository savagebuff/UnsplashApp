//
//  DetailViewController.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 05.06.2022.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - properties
    private let selectPhoto: Photo
    
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
    }
}
