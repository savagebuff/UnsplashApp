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
