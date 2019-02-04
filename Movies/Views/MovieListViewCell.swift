//
//  MovieListViewCell.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/3/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class MovieListViewCell: UITableViewCell {
    static var identifier = "MovieListViewCell"
    
    private enum Constants {
        static let posterViewWidth: CGFloat = 70.0
        static let titleFontSize: CGFloat = 16.0
        static let subtitleFontSize: CGFloat = 14.0
        static let labelHeight: CGFloat = 22.0
        static let margin: CGFloat = 20.0
    }
    
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
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constants.subtitleFontSize)
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
    
    func setMovieTitle(_ title: String?) {
        movieTitleLabel.text = title
        movieTitleLabel.invalidateIntrinsicContentSize()
    }
    
    func setReleaseDate(_ releaseDate: String?) {
        releaseDateLabel.text = releaseDate
        invalidateIntrinsicContentSize()
    }
}

private extension MovieListViewCell {
    func commonInit() {
        selectionStyle = .none
        
        contentView.addSubview(posterView)
        
        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterView.widthAnchor.constraint(equalToConstant: Constants.posterViewWidth)])
        
        NSLayoutConstraint.activate([
            movieTitleLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight)])
        
        let stackView = UIStackView(arrangedSubviews: [movieTitleLabel, releaseDateLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: Constants.margin),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin),
            stackView.topAnchor.constraint(equalTo: posterView.topAnchor, constant: Constants.margin)])
    }
}
