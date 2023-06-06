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
    private let networkManager = NetworkManager()
    
    func fetchMovieDetails(_ id: Int) async {
        
        mainThread {
            KRProgressHUD.showProgress()
        }
        
        do {
            self.movie.value = try await networkManager.fetchMovieDetails(model: Movie.self,
                                                                          id: id)
        } catch {
            self.movie.value = nil
            mainThread {
                KRProgressHUD.dismiss()
            }
        }
    }
}
