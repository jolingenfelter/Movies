//
//  MovieListViewCell.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/3/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class MovieListViewCell: UITableViewCell {
    private enum Constants {
        static let posterViewWidth: CGFloat = 70.0
        static let titleFontSize: CGFloat = 16.0
    }
    
    static var identifier = "MovieListViewCell"
    
    private lazy var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    func loadMoviePoster(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.posterView.image = image
        }
    }
}

private extension MovieListViewCell {
    func commonInit() {
        contentView.addSubview(posterView)
        
        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterView.widthAnchor.constraint(equalToConstant: Constants.posterViewWidth)])
        
        let stackView = UIStackView(arrangedSubviews: [movieTitleLabel])
    }
}
