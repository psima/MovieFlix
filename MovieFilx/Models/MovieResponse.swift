//
//  MovieResponse.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 25/2/25.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let overview: String
    let backdropPath: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIDs: [Int]
    let video: Bool

    enum CodingKeys: String, CodingKey {
        case id, adult, title, overview, video
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case genreIDs = "genre_ids"
    }
    
    // this is only for the preview
    static func movieForPreview() -> Movie {
        Movie(id: 1, adult: false, title: "", originalTitle: "", originalLanguage: "", overview: "", backdropPath: nil, posterPath: nil, releaseDate: nil, voteAverage: 10, voteCount: 10, popularity: 10, genreIDs: [], video: false)
    }
}
