//
//  UIViewController+extensions.swift
//  MoviesList
//
//  Created by Anton Stremovskiy on 20.01.23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Loading error",
                          message: "Cannot parse data at this time",
                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}
