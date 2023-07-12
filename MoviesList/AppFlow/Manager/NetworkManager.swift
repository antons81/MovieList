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

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case invalidData
}


final class NetworkManager {
    
    private let session: URLSession!
    private let host = "api.themoviedb.org"
    
    init() {
        session = URLSession(configuration: .default)
    }
    
    private func runTask<T: Decodable>(with url: URL,
                                       model: T.Type,
                                       key: String? = nil) async throws -> T {
        
        let (data,_) = try await session.data(from: url)
        
        if key == nil {
            return try JSONDecoder().decode(model, from: data)
        }
        
        return try JSONDecoder().decode(model,
                                        from: data,
                                        keyPath: key ?? "")
        
    }
    
    func fetchMovieDetails<T: Decodable>(model: T.Type,
                                            id: Int) async throws -> T {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = self.host
        urlComponent.path = EndPoints.details(id).endPoint
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: "c9856d0cb57c3f14bf75bdc6c063b8f3")
        ]
        
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        
        let response = try await runTask(with: url, model: model)
        return response
    }
    
    func fetchTrendingMovies<T: Decodable>(model: T.Type) async throws -> T {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = self.host
        urlComponent.path = EndPoints.trending.endPoint
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: "c9856d0cb57c3f14bf75bdc6c063b8f3")
        ]
        
        guard let url = urlComponent.url else {
            throw NetworkError.invalidURL
        }
        
        let response = try await runTask(with: url, model: model, key: "results")
        return response
    }
}
