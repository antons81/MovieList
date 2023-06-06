//
//  MainViewModel.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import Foundation
import KRProgressHUD

typealias Movies = [MovieModel]

final class MovieViewModel: NSObject {
    
    // MARK: - Observers
    var movies: ObservableObject<Movies> = ObservableObject(nil)
    var currentMovieId: ObservableObject<Int> = ObservableObject(nil)
    
    // MARK: - Private variables
    private var tempMovies = Movies()
    private let networkManager = NetworkManager()
    
    func composeMovies() async {
        mainThread {
            KRProgressHUD.showProgress()
        }
        
        do {
            let movies = try await networkManager.fetchTrendingMovies(model: Movies.self)
            self.movies.value = movies
            self.tempMovies = self.movies.value ?? Movies()
        } catch {
            self.movies.value = nil
            mainThread {
                KRProgressHUD.dismiss()
            }
        }
    }
}

extension MovieViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as MovieCell
        return cell
    }
}

extension MovieViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MovieCell, let values = self.movies.value {
            let movie = values[indexPath.row]
            cell.setupCell(movie)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let values = self.movies.value else { return }
        let currentMovie = values[indexPath.row]
        self.currentMovieId.value = currentMovie.id
    }
}

extension MovieViewModel: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.movies.value = self.tempMovies
            return
        }
        
        let newData = self.movies.value?.filter { $0.title.contains(searchText) }
        self.movies.value = newData
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.movies.value = self.tempMovies
    }
}
