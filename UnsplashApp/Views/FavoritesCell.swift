//
//  FavoritesCell.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 05.06.2022.
//

import Foundation
import UIKit
import SDWebImage

class FavoritesCell: UICollectionViewCell {
    // MARK: - properties
    static let identifier = "FavoritesCell"
    
    private var photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let photoNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var unsplashPhoto: Photo! {
        didSet {
            let photoUrl = unsplashPhoto.urls["small"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            
            photoNameLabel.text = unsplashPhoto.user.name
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    // MARK: - livecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoNameLabel.frame = CGRect(
            x: 3,
            y: contentView.height-60,
            width: contentView.width-6,
            height: 30
        )
        let imageSize = contentView.height-70
        
        photoImageView.frame = CGRect(
            x: (contentView.width-imageSize)/2,
            y: 3,
            width: imageSize,
            height: imageSize
        )
    }
}

extension FavoritesCell {
    // MARK: - reuse cell
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoNameLabel.text = nil
    }
    
    // MARK: - setup
    private func setupUI() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(photoNameLabel)
    }
}
