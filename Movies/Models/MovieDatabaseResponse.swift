//
//  MovieDatabaseResponse.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/3/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

struct MovieDatabaseResponse<T: Codable>: Codable {
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
    
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [T]
}
