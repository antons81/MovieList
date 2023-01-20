//
//  NetworkManager.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import UIKit

private enum EndPoints {
    case trending
    case details(_ movieId: Int)
}

private extension EndPoints {
    
    var endPoint: String {
        switch self {
        case .trending: return "/3/discover/movie"
        case .details(let id): return "/3/movie/\(id)"
        }
    }
}


final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    static private let host = "api.themoviedb.org"
    
    private func runTask<T: Decodable>(with request: URLRequest,
                                       model: T.Type,
                                       key: String? = nil,
                                       completion: ((T) -> Void)?,
                                       errorCompletion: ((Error?) -> Void)?) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if key == nil {
                    if let response = try? JSONDecoder().decode(model, from: data) {
                        completion?(response)
                        return
                    }
                } else {
                    if let response = try? JSONDecoder().decode(model,
                                                                from: data,
                                                                keyPath: key ?? "") {
                        completion?(response)
                        return
                    }
                }
            }
            errorCompletion?(error)
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
        .resume()
    }
    
    func fetchMovieDetails<T: Decodable>(model: T.Type,
                                            id: Int,
                                            completion: ((T) -> Void)?,
                                            errorCompletion: ((Error?) -> Void)?) {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = NetworkManager.host
        urlComponent.path = EndPoints.details(id).endPoint
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: "c9856d0cb57c3f14bf75bdc6c063b8f3")
        ]
        
        guard let url = urlComponent.url else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        runTask(with: request, model: model) { response in
            completion?(response)
        } errorCompletion: { error in
            errorCompletion?(error)
        }
    }
    
    func fetchTrendingMovies<T: Decodable>(model: T.Type,
                                       completion: ((T) -> Void)?,
                                       errorCompletion: ((Error?) -> Void)?) {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = NetworkManager.host
        urlComponent.path = EndPoints.trending.endPoint
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: "c9856d0cb57c3f14bf75bdc6c063b8f3")
        ]
        
        guard let url = urlComponent.url else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        runTask(with: request, model: model, key: "results") { response in
            completion?(response)
        } errorCompletion: { error in
            errorCompletion?(error)
        }
    }
}
