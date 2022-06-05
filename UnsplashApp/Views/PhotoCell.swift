//
//  PhotoCell.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 04.06.2022.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    // MARK: - properties
    static let identifier = "PhotoCell"
    
    private let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var unsplashPhoto: Photo! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    // MARK: - livecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPhoto()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - reuse cell
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

extension PhotoCell {
    // MARK: - setup
    private func setupPhoto() {
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
