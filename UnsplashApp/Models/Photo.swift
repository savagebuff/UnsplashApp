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
