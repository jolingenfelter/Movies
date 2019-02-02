//
//  Movie.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

struct Movie: Codable {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case title
        case releaseDate = "release_date"
        case overview
        case id
        case posterPath = "poster_path"
    }
    let title: String?
    let releaseDate: String?
    let overview: String?
    let id: Int?
    let posterPath: String?
}
