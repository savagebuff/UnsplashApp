//
//  SearchRequestResults.swift
//  UnsplashApp
//
//  Created by Dinar Garaev on 04.06.2022.
//

import Foundation

struct SearchRequestResults: Codable {
    let total: Int
    let results: [Photo]
}

struct Photo: Codable {
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
        case small_s3
    }
}
