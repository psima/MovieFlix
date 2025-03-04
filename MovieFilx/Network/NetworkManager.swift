//
//  NetworkManager.swift
//  MovieFilx
//
//  Created by Pavlos Simas on 25/2/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case unknownError(Error)
}

func makeAPIRequest<T: Decodable>(url: URL, method: HTTPMethod, body: Data? = nil, headers: [String: String]? = nil) async throws -> T {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue

    // Add default headers
    let defaultHeaders = [
        "Authorization": "Bearer \(Constants.apiKey)",
        "accept": "application/json"
    ]

    // Merge default headers with provided headers (if any)
    let allHeaders = defaultHeaders.merging(headers ?? [:]) { $1 }
    for (key, value) in allHeaders {
        request.setValue(value, forHTTPHeaderField: key)
    }

    request.httpBody = body

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        if let _ = error as? DecodingError {
            throw NetworkError.decodingError
        } else {
            throw NetworkError.unknownError(error)
        }
    }
}

func getPopularMovies(page: Int) async throws -> MovieResponse {
    guard let url = URL(string: "\(Constants.baseURLString)/movie/popular?language=en-US&page=\(page)") else { throw NetworkError.invalidURL }
    return try await makeAPIRequest(url: url, method: .GET)
}

func searchMovie(query: String, page: Int) async throws -> MovieResponse {
    guard let url = URL(string: "\(Constants.baseURLString)/search/movie?query=\(query)&include_adult=false&language=en-US&page=\(page)") else { throw NetworkError.invalidURL }
    return try await makeAPIRequest(url: url, method: .GET)
}

func getMovieDetails(movieId: Int) async throws -> MovieDetails {
    guard let url = URL(string: "\(Constants.baseURLString)/movie/\(movieId)?language=en-US") else { throw NetworkError.invalidURL }
    return try await makeAPIRequest(url: url, method: .GET)
}

func getSimilarMovies(movieId: Int, page: Int) async throws -> MovieResponse {
    guard let url = URL(string: "\(Constants.baseURLString)/movie/\(movieId)/similar?language=en-US&page=\(page)") else { throw NetworkError.invalidURL }
    return try await makeAPIRequest(url: url, method: .GET)
}

func getMovieReviews(movieId: Int, page: Int) async throws -> Reviews {
    guard let url = URL(string: "\(Constants.baseURLString)/movie/\(movieId)/reviews?language=en-US&page=\(page)") else { throw NetworkError.invalidURL }
    return try await makeAPIRequest(url: url, method: .GET)
}
