//
//  Alert.swift
//  ImageFeed
//
//  Created by Сергей Андреев on 10.01.2023.
//

import UIKit

final class ErrorAlertViewController {
    func showAlert(
        over viewController: UIViewController,
        title: String,
        message: String?,
        actionTitle: String,
        onDismiss: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let dismissAction = UIAlertAction(
            title: actionTitle,
            style: .default
        ) { _ in
            onDismiss()
        }
        alert.addAction(dismissAction)
        
        viewController.present(alert, animated: true)
    }
}
