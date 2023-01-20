//
//  DailyWeatheViewController.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import UIKit
import KRProgressHUD
import Kingfisher

final class MovieDetailsViewController: UIViewController {
    
    // MARK: - Private variables
    @IBOutlet weak private var originalTitle: UILabel!
    @IBOutlet weak private var overview: UILabel!
    @IBOutlet weak private var releaseDate: UILabel!
    @IBOutlet weak private var rating: UILabel!
    @IBOutlet weak private var poster: UIImageView!
    @IBOutlet weak private var budget: UILabel!
    @IBOutlet weak private var prodLogo: UIImageView!
    @IBOutlet weak private var prodName: UILabel!
    
    // MARK: - Private variables
    private let viewModel = MovieDetailsViewModel()
    private var movie: Movie?
    
    // MARK: - Public variables
    var movieId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.binds()
        self.composeData()
    }
}

extension MovieDetailsViewController {
    
    fileprivate func binds() {
        viewModel.movie.bind { [weak self] movie in
            mainThread {
                self?.updateDetails(movie)
                KRProgressHUD.dismiss()
            }
        }
    }
    
    fileprivate func composeData() {
        self.viewModel.fetchMovieDetails(movieId)
    }
    
    fileprivate func updateDetails(_ movie: Movie?) {
        guard let movie = movie else { return }
        self.originalTitle.text = movie.title
        self.overview.text = movie.overview
        self.releaseDate.text = movie.releaseDate.stringToDate(with: "YYYY-MM-dd").dateToString(with: "dd MMMM YYYY")
        self.rating.text = "Average rate: " + movie.voteAverage.format2Decimals
        
        if let url = URL(string: movie.posterPath?.imageURL ?? "") {
            self.poster.kf.setImage(with: url)
        }
        
        self.budget.text = "Budget: $\(movie.budget)"
        
        if let prod = movie.productionCompanies.first,
           let url = URL(string: prod.logoPath?.imageURL ?? "") {
            self.prodLogo.kf.setImage(with: url)
            self.prodName.text = prod.name
        }
    }
    
    fileprivate func setupUI() {
        self.title = self.movie?.title
    }
}
