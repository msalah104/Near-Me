//
//  UIViewController+Extension.swift
//  Near Me
//
//  Created by Mohammed Salah on 13/04/2020.
//  Copyright © 2020 MSalah. All rights reserved.
//

import UIKit

extension UIViewController {
    func showErrorMessage(title: String, message: String, customAction: UIAlertAction? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let action = customAction {
            alert.addAction(action)
        } else {
            let action = UIAlertAction(title: "OK", style: .cancel, handler: handler)
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
}
