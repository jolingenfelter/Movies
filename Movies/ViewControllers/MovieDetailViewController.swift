//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/2/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

private extension MovieDetailViewController {
    func setupView() {
        guard let movie = movie else {
            return
        }
        
        self.title = movie.title
        
        overviewTextView.text = movie.overview
        
        movie.getMoviePoster { image in
            DispatchQueue.main.async {
                self.posterView.image = image
            }
        }
    }
}
