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
    let imageURL: String?
    
    private let posterPath: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decodeIfPresent(String.self, forKey: .title)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        
        if let posterPath = posterPath {
            imageURL = "https://image.tmdb.org/t/p/w500\(posterPath)"
        } else {
            imageURL = nil
        }
    }
}
