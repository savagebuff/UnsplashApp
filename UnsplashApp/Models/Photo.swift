//
//  Photo.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 05.06.2022.
//

import Foundation

struct Photo: Codable {
    let created_at: String
    let downloads: Int?
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue: String]
    let location: Location?
    let user: User
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
        case small_s3
    }
}

extension Photo: Hashable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.user.name == rhs.user.name && lhs.created_at == rhs.created_at
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(created_at)
        hasher.combine(user.name)
        hasher.combine(urls["regular"])
    }
}
