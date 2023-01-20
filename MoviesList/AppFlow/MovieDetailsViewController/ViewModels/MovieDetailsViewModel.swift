//
//  MovieDetailsViewModel.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import Foundation
import KRProgressHUD

typealias Movie = MovieDetailsModel

final class MovieDetailsViewModel: NSObject {
    
    // MARK: - Observers
    var movie: ObservableObject<Movie> = ObservableObject(nil)
    
    func fetchMovieDetails(_ id: Int) {
        KRProgressHUD.showProgress()
        NetworkManager.shared.fetchMovieDetails(model: Movie.self,
                                                id: id) { [weak self] movie in
            self?.movie.value = movie
        } errorCompletion: { _ in
            self.movie.value = nil
        }
    }
}
