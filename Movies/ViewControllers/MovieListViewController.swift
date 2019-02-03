//
//  MovieListViewController.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieDatabaseClient = MovieDatabaseClient()
        movieDatabaseClient.fetchPopularMovies { result in
            switch result {
            case .success(let movies):
                print(movies)
            case .failure(let error):
                print(error)
            }
        }
    }
}

