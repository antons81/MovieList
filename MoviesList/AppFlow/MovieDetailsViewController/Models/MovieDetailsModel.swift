//
//  MovieDetailsModel.swift
//  MovieList
//
//  Created by Anton Stremovskiy on 19.01.2023.
//

import Foundation

// MARK: - MovieDetailsModel
struct MovieDetailsModel: Codable {
    let id: Int
    let title: String
    let budget: Int
    let overview: String?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "original_title"
        case budget = "budget"
        case overview = "overview"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.budget = try container.decode(Int.self, forKey: .budget)
        self.overview = try? container.decode(String.self, forKey: .overview)
        self.posterPath = try? container.decode(String.self, forKey: .posterPath)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.productionCompanies = try container.decode([ProductionCompany].self, forKey: .productionCompanies)
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case logoPath = "logo_path"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.logoPath = try? container.decode(String.self, forKey: .logoPath)
    }
}
