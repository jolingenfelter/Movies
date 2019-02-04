//
//  Movie+Image.swift
//  Movies
//
//  Created by Joanna LINGENFELTER on 2/3/19.
//  Copyright © 2019 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

extension Movie {
    func getMoviePoster(completion: @escaping ((UIImage?) -> Void)) {
        if let imageURLString = imageURL, let imageURL =  URL(string: imageURLString) {
            ImageGetter.sharedInstance.getImage(from: imageURL) { result in
                switch result {
                case .success(let image):
                    completion(image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
}
