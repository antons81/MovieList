//
//  UIImage+extensions.swift
//  MoviesList
//
//  Created by Anton Stremovskiy on 05.07.23.
//

import Foundation
import UIKit

extension UIImageView {
    
    func imageFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            mainThread {
                self.image = UIImage(data: data)
            }
        }.resume()
    }
}
