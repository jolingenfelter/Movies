//
//  UIViewController+Alert.swift
//  Movies
//
//  Created by Joanna Lingenfelter on 2/3/19.
//  Copyright © 2018 Neighborhood Goods. All rights reserved.
//

import UIKit

typealias AlertActionHandler = ((UIAlertAction) -> ())

extension UIViewController {
    func display(alert error: Error?) {
        if let error = error {
            display(alert: "Error", message: error.localizedDescription)
        }
    }

    func display(alert title: String, message: String, okHandler: AlertActionHandler? = nil, okIsDestructive: Bool = false, canCancel: Bool = false, cancelHandler: AlertActionHandler? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: okIsDestructive ? .destructive : .cancel, handler: okHandler))

        if canCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancelHandler))
        }

        present(alertController, animated: true, completion: nil)
    }
}
