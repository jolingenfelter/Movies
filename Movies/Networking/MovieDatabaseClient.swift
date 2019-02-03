//
//  MovieDatabaseClient.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

typealias MovieResultHandler = (Result<[Movie]>) -> Void

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
        fetchFromMovieDatabase(endpoint: .popularMovies, successHandler: { (movies: [Movie]) in
            movieResult(.success(movies))
        }) { error in
            movieResult(.failure(error))
        }
    }
}

private extension MovieDatabaseClient {
    func fetchFromMovieDatabase<T: Codable>(endpoint: MovieDatabaseEndpoint, successHandler: (([T]) -> Void)?, failureHandler: ((Error) -> Void)?){
        guard let url = endpoint.createURL() else {
            failureHandler?(AppError.invalidURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        fetchData(withRequest: request) { fetchedResult in
            switch fetchedResult {
            case .success(let data):
                do {
                    let object = try JSONDecoder().decode(MovieDatabaseResponse<T>.self, from: data)
                    successHandler?(object.results)
                } catch {
                    failureHandler?(error)
                }
            case .failure(let error):
               failureHandler?(error)
            }
        }
    }
}
