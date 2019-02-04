//
//  MovieListViewController.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    private enum Constants {
        static let rowHeight: CGFloat = 128.0
    }
    
    private let movieDatabaseClient = MovieDatabaseClient()
    private var movies: [Movie] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchMovies()
    }
}

private extension MovieListViewController {
    func setupView() {
        self.title = "Popular Movies"
    }
    
    func fetchMovies() {
        LoadingView.show(in: self.view)
        
        movieDatabaseClient.fetchPopularMovies { [weak self] result in
            guard let sself = self else { return }
            
            switch result {
            case .success(let movies):
                sself.movies = movies
                sself.tableView.reloadData()
            case .failure(let error):
                sself.display(alert: error)
            }
            
            LoadingView.hide(for: sself.view)
        }
    }
}

// MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListViewCell.identifier) as? MovieListViewCell else {
            fatalError("Could not dequeue cell: \(MovieListViewCell.self)")
        }
        
        let movie = movies[indexPath.row]
        
        movie.getMoviePoster() { image in
            cell.loadMoviePoster(image)
        }
        
        cell.setMovieTitle(movie.title)
        cell.setReleaseDate(movie.releaseDate)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: StoryboardConstants.main, bundle: nil)
        let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: StoryboardConstants.movieDetailViewController) as! MovieDetailViewController
        movieDetailViewController.movie = movies[indexPath.row]
        
        navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

