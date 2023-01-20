//
//  MovieCell.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import UIKit
import Kingfisher

final class MovieCell: UITableViewCell, NibReusable {
    
    // MARK: - Outlets
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var overview: UILabel!
    @IBOutlet weak private var releaseDate: UILabel!
    @IBOutlet weak private var rating: UILabel!
    @IBOutlet weak private var poster: UIImageView!

    func setupCell(_ movie: MovieModel) {
        self.title.text = movie.title
        self.overview.text = movie.overview
        self.releaseDate.text = movie.releaseDate.stringToDate(with: "YYYY-MM-dd").dateToString(with: "dd MMMM YYYY")
        self.rating.text = "Average rate: " + movie.voteAverage.toString
        if let url = URL(string: movie.posterPath?.imageURL ?? "") {
            self.poster.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.poster.image = nil
        self.title.text = nil
    }
}
