//
//  MovieDatabaseClient.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

typealias MovieResultHandler = (APIResult<[Movie]>) -> Void

final class MovieDatabaseClient: APIClient {
    let configuration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetchPopularMovies(movieResult: @escaping MovieResultHandler) {
        fetchFromMovieDatabase(endpoint: .popularMovies) { apiResult in
            do {
                switch apiResult {
                case .success(let data):
                    let movies = try JSONDecoder().decode([Movie].self, from: data)
                    movieResult(.success(movies))
                case .failure(let error):
                    movieResult(.failure(error))
                }
            } catch {
                movieResult(.failure(error))
            }
        }
    }
}

private extension MovieDatabaseClient {
    func fetchFromMovieDatabase(endpoint: MovieDatabaseEndpoint, result: @escaping APIResultHandler) {
        guard let url = endpoint.createURL() else {
            result(.failure(AppError.invalidURL))
            return
        }
        
        print(url)
        
        let request = URLRequest(url: url)
        
        fetchData(withRequest: request, result: result)
    }
}
