//
//  SavedPhotos.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 05.06.2022.
//

import Foundation

final class SavedPhotos {
    static let shared = SavedPhotos()
    
    private init() {}
    
    var savedPhoto = Set<Photo>()
}
