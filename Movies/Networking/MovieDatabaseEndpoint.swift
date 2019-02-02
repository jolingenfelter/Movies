//
//  MovieDatabaseEndpoint.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

enum MovieDatabaseEndpoint {
    case popularMovies
    
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    private var apiKey: String {
        return "629dffce2b8a8f3cf597af9e1c49fdcf"
        
    }
    
    func createURL(withQuery query: Int?) throws -> URL {
        switch self {
        case .popularMovies:
            guard let url =  URL(string: "\(baseURL)discover/movie?sort_by=popularity.descapi_key=\(apiKey)") else {
                throw AppError.invalidURL
            }
            
            return url
        }
    }
    
}
